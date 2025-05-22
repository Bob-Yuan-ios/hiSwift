//
//  SocketServerCandidate.swift
//  HiSwift
//
//  Created by Bob on 2025/5/22.
//


//
//  MultiDomainTCPManager.swift
//


/*
 多域名 + 多IP统一测速调度
 对每个域名都进行 DNS 解析，获取其多个 IP，汇总全部候选IP后统一测速，选择延迟最低的服务器连接。

 本地持久化成功域名/IP作为首选
 上次成功连接的IP/domain，优先尝试，避免重复测速消耗
 可存储在UserDefaults中，加快后续冷启动连接速度
 
 DNS 动态解析
 支持多个域名优选连接
 实时测速选择最优 IP
 DNS 定时刷新
 网络恢复监听并重连
 */

import Foundation
import Network

// MARK: - Server Candidate

struct SocketServerCandidate {
    let domain: String
    let port: UInt32
    var lastFailedTime: Date?
    var banDuration: TimeInterval = 300 // seconds
}

// MARK: - DNS Resolver

class DNSResolver {
    static func resolve(_ domain: String, completion: @escaping ([String]) -> Void) {
        DispatchQueue.global().async {
            var results: [String] = []
            let host = CFHostCreateWithName(nil, domain as CFString).takeRetainedValue()
            CFHostStartInfoResolution(host, .addresses, nil)

            var success: DarwinBoolean = false
            if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?, success.boolValue {
                for case let data as NSData in addresses {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    let sockAddr = data.bytes.assumingMemoryBound(to: sockaddr.self)
                    if getnameinfo(sockAddr, socklen_t(data.length), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                        let ip = String(cString: hostname)
                        results.append(ip)
                    }
                }
            }
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }
}

// MARK: - TCP Client

class TCPClient: NSObject, StreamDelegate {
    let host: String
    let port: UInt32

    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    
    var onDisconnect: (() -> Void)?
    var onReceive: ((Data) -> Void)?

    init(host: String, port: UInt32) {
        self.host = host
        self.port = port
    }

    func connect() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?

        CFStreamCreatePairWithSocketToHost(nil, host as CFString, port, &readStream, &writeStream)

        guard let input = readStream?.takeRetainedValue(), let output = writeStream?.takeRetainedValue() else {
            onDisconnect?()
            return
        }

        inputStream = input
        outputStream = output

        inputStream?.delegate = self
        outputStream?.delegate = self

        inputStream?.schedule(in: .current, forMode: .default)
        outputStream?.schedule(in: .current, forMode: .default)

        inputStream?.open()
        outputStream?.open()
    }

    func disconnect() {
        inputStream?.close()
        outputStream?.close()
        inputStream?.remove(from: .current, forMode: .default)
        outputStream?.remove(from: .current, forMode: .default)
    }

    func send(data: Data) {
        _ = data.withUnsafeBytes {
            outputStream?.write($0.bindMemory(to: UInt8.self).baseAddress!, maxLength: data.count)
        }
    }

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            if let input = inputStream {
                var buffer = [UInt8](repeating: 0, count: 1024)
                let length = input.read(&buffer, maxLength: 1024)
                if length > 0 {
                    let data = Data(bytes: buffer, count: length)
                    onReceive?(data)
                }
            }
        case .errorOccurred, .endEncountered:
            disconnect()
            onDisconnect?()
        default:
            break
        }
    }
}

// MARK: - Manager

final class MultiDomainTCPManager {
    private var candidates: [SocketServerCandidate]
    private var activeClient: TCPClient?
    private var heartbeatTimer: Timer?
    private var dnsRefreshTimer: Timer?
    private var monitor: NWPathMonitor?
    
    private var lastPongTime: Date = Date()

    init(domains: [SocketServerCandidate]) {
        self.candidates = domains
        startNetworkMonitor()
    }

    func start() {
        selectAndConnect()
        startDNSRefreshTimer()
    }

    func stop() {
        heartbeatTimer?.invalidate()
        dnsRefreshTimer?.invalidate()
        monitor?.cancel()
        activeClient?.disconnect()
    }

    private func selectAndConnect() {
        let availableCandidates = candidates.enumerated().filter { index, candidate in
            guard let failedAt = candidate.lastFailedTime else { return true }
            return Date().timeIntervalSince(failedAt) > candidate.banDuration
        }

        guard !availableCandidates.isEmpty else {
            retryAfterDelay()
            return
        }

        resolveAndSelectBest(from: availableCandidates) { [weak self] result in
            guard let self = self else { return }
            if let (ip, port, domainIndex) = result {
                self.connectTo(ip: ip, port: port, domainIndex: domainIndex)
            } else {
                self.retryAfterDelay()
            }
        }
    }

    private func resolveAndSelectBest(from candidates: [(offset: Int, element: SocketServerCandidate)],
                                      completion: @escaping ((String, UInt32, Int)?) -> Void) {
        let group = DispatchGroup()
        var latencies: [(String, UInt32, TimeInterval, Int)] = []

        for (index, candidate) in candidates {
            group.enter()
            DNSResolver.resolve(candidate.domain) { ips in
                let innerGroup = DispatchGroup()
                for ip in ips {
                    innerGroup.enter()
                    self.measureLatency(to: ip, port: candidate.port) { rtt in
                        if let rtt = rtt {
                            latencies.append((ip, candidate.port, rtt, index))
                        }
                        innerGroup.leave()
                    }
                }
                innerGroup.notify(queue: .main) { group.leave() }
            }
        }

        group.notify(queue: .main) {
            let best = latencies.sorted(by: { $0.2 < $1.2 }).first
            if let best = best {
                completion((best.0, best.1, best.3))
            } else {
                completion(nil)
            }
        }
    }

    private func measureLatency(to ip: String, port: UInt32, completion: @escaping (TimeInterval?) -> Void) {
        var input: InputStream?
        var output: OutputStream?
        Stream.getStreamsToHost(withName: ip, port: Int(port), inputStream: &input, outputStream: &output)

        let start = Date()
        input?.open()
        output?.open()

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
            input?.close()
            output?.close()
            completion(Date().timeIntervalSince(start))
        }
    }

    private func connectTo(ip: String, port: UInt32, domainIndex: Int) {
        activeClient?.disconnect()
        let client = TCPClient(host: ip, port: port)

        client.onReceive = { [weak self] data in
            if String(data: data, encoding: .utf8) == "PONG" {
                self?.lastPongTime = Date()
            }
        }

        client.onDisconnect = { [weak self] in
            self?.candidates[domainIndex].lastFailedTime = Date()
            self?.retryAfterDelay()
        }

        client.connect()
        startHeartbeat(on: client)
        activeClient = client
    }

    private func startHeartbeat(on client: TCPClient) {
        heartbeatTimer?.invalidate()
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if Date().timeIntervalSince(self.lastPongTime) > 20 {
                self.activeClient?.disconnect()
            } else {
                client.send(data: "PING".data(using: .utf8)!)
            }
        }
    }

    private func retryAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.selectAndConnect()
        }
    }

    private func startDNSRefreshTimer() {
        dnsRefreshTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            self?.selectAndConnect()
        }
    }

    private func startNetworkMonitor() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.selectAndConnect()
            }
        }
        monitor?.start(queue: .global())
    }

    func send(data: Data) {
        activeClient?.send(data: data)
    }
}
