//
//  CategoryHome.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//

import SwiftUI

struct CategoryHome: View {
    
    @Environment(ModelData.self) var modelData
    var body: some View {
        NavigationSplitView{
            
            List{
                modelData.features[0].image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                
                ForEach(modelData.categores.keys.sorted(), id:\.self){ key in
                    CategoryRow(categoryName: key, items: modelData.categores[key]!)
                }
                .listRowInsets(EdgeInsets())
            }
            .navigationTitle("Featured")
         
        } detail: {
            Text("Selected a Landmark")
        }
    }
}

#Preview {
    CategoryHome()
        .environment(ModelData())
}
