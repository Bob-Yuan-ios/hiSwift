//
//  HiSwiftApp.swift
//  HiSwift
//
//  Created by Bob on 2024/10/31.
//  

import SwiftUI

@main
struct HiSwiftApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: MyAppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }    
}
