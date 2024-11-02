//
//  ContentView.swift
//  HiSwift
//
//  Created by Bob on 2024/10/31.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        LandmarkList()
    }
    
}

#Preview {
    ContentView().environment(ModelData())
}
