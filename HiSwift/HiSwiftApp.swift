//
//  HiSwiftApp.swift
//  HiSwift
//
//  Created by Bob on 2024/10/31.
//  参考链接：https://www.swiftbysundell.com/articles/making-swiftui-views-refreshable/

import SwiftUI

@main
struct HiSwiftApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: MyAppDelegate

    var body: some Scene {
        WindowGroup {
//            ContentView()
            BookMarkListView(viewModel: BookMarkListModel())
        }
    }    
}
