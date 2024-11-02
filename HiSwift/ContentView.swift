//
//  ContentView.swift
//  HiSwift
//
//  Created by Bob on 2024/10/31.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection: Tab = .featured
    
    enum Tab{
        case featured
        case landlist
        case booklist
    }
    
    var body: some View {
        
        TabView(selection: $selection) {
            CategoryHome()
                .tabItem({
                    Label("Featured", systemImage: "star")
                })
                .tag(Tab.featured)
            
            LandmarkList()
                .tabItem({
                    Label("List", systemImage: "list.bullet")
                })
                .tag(Tab.landlist)
            
            BookmarkListView(viewModel: BookmarkListModel())
                .tabItem ({
                    Label("Book", systemImage: "checkmark.circle")
                })
                .tag(Tab.booklist)
        }
    }
    
}

#Preview {
    ContentView().environment(ModelData())
}
