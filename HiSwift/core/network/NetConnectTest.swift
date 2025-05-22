//
//  NetConnectTest.swift
//  HiSwift
//
//  Created by Bob on 2025/5/22.
//

import Foundation

class NetConnectTest: NSObject {
    
    var socketManager: MultiDomainTCPManager?

    
    func connect() {
        
        let servers = [
                 SocketServerCandidate(domain: "socket-cn.example.com", port: 9000),
                 SocketServerCandidate(domain: "socket-us.example.com", port: 9000)
             ]
             socketManager = MultiDomainTCPManager(domains: servers)
             socketManager?.start()
        
        
        let message = ["cmd": "ping", "time": Date().timeIntervalSince1970] as [String : Any]
               if let data = try? JSONSerialization.data(withJSONObject: message) {
                   socketManager?.send(data: data)
               }
    }
}
