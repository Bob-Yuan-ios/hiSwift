//
//  LandmarkList.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//  参考链接：

import SwiftUI

struct LandmarkList: View {
    var body: some View {
        NavigationSplitView{
            List(landmarks){ landmark in
                NavigationLink{
                    LandmarkDetail(landmark: landmark)
                } label: {
                    LandmarkRow(landmark: landmark)
                }
            }
            .navigationTitle("Landmarks")
        } detail: {
            // on ipad显示选中
            Text("Selected a Landmark")
        }
    }
}

#Preview {
    LandmarkList()
}
