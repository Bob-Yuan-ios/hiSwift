//
//  CategoryHome.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//

import SwiftUI

struct CategoryHome: View {
    
    @Environment(ModelData.self) var modelData
    @State private var showingProfile = false
    
    var body: some View {
        NavigationSplitView{
            
            List{
//                modelData.features[0].image
//                    .resizable()
//                    .scaledToFill()
//                    .frame(height: 200)
//                    .clipped()
//                    .listRowInsets(EdgeInsets())
                
                PageView(pages: modelData.features.map{
                    FeatureCard(landmark: $0)
                })
                .listRowInsets(EdgeInsets())
                ForEach(modelData.categores.keys.sorted(), id:\.self){ key in
                    CategoryRow(categoryName: key, items: modelData.categores[key]!)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.inset)
            .navigationTitle("Featured")
            .toolbar{
                Button{
                    showingProfile.toggle()
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environment(modelData)
            }
            
        } detail: {
            Text("Selected a Landmark")
        }
    }
}

#Preview {
    CategoryHome()
        .environment(ModelData())
}
