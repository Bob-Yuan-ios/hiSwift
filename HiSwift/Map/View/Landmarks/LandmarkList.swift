//
//  LandmarkList.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//  参考链接：

import SwiftUI

struct LandmarkList: View {
    
    @Environment(ModelData.self) var modelData
    
    /*
     @State 是 SwiftUI 中的一个属性包装器，用于在视图中管理可变状态。
     它使得视图能够在内部保存和修改状态，自动跟踪状态的变化并重新渲染视图。
     这对于构建交互式用户界面非常重要。

     用途
     局部状态管理：@State 适合用于管理仅与特定视图相关的状态，而不需要在整个应用中共享。
     视图更新：当状态改变时，SwiftUI 会自动更新使用该状态的视图，从而实现动态界面。
     */
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
