//
//  LandmarkList.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//  参考链接：

import SwiftUI

struct LandmarkList: View {
    
    @Environment(ModelData.self) var modelData
    @State private var showFavoritesOnly = false
    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter{ landmark in
            
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        NavigationSplitView{
            
            Toggle(isOn: $showFavoritesOnly, label: {
                Text("Favorites Only")
            }).padding()
            
            List(filteredLandmarks){ landmark in
                NavigationLink{
                    LandmarkDetail(landmark: landmark)
                } label: {
                    LandmarkRow(landmark: landmark)
                }
            }
            .animation(.default, value: filteredLandmarks)
            .navigationTitle("Landmarks")
        } detail: {
            // on ipad显示选中
            Text("Selected a Landmark")
        }
    }
}

#Preview {
    LandmarkList().environment(ModelData())
}
