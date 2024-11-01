//
//  BookMarkListModel.swift
//  HelloSwift
//
//  Created by Bob on 2024/11/1.
//

import Foundation

class BookMarkListModel: ObservableObject{
    
    @Published private(set) var bookmarks = [
        "Apple"
    ]
    
    func reload() async throws{
        sleep(2) // 模拟耗时
        await appendingData()
    }
    
    @MainActor
    func appendingData() {
        bookmarks.append("aaaa")
    }
}

