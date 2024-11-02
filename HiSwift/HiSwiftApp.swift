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
    @State private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView().environment(modelData)
        }
    }    
}
