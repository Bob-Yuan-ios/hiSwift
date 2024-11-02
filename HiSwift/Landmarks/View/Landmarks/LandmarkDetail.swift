//
//  LandmarkDetail.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//

import SwiftUI

struct LandmarkDetail: View {
    
    /*
     @Environment 是 SwiftUI 中的一个属性包装器，用于访问和共享环境值。
     它允许视图从其上下文中获取数据，这些数据可能是在应用的更高层次设置的，
     像是主题、用户设置或其他共享状态。
     @Environment非常适合用于在视图层次结构中传递信息，
     而不需要通过每个视图手动传递参数。
     */
    @Environment(ModelData.self) var modelData
    var landmark: Landmark
    
    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: { $0.id == landmark.id})!
    }
    var body: some View {
        
        /*
         @Bindable 是 SwiftUI 中一个相对较新的属性包装器，旨在简化 ObservableObject 的属性绑定。它使得在 SwiftUI 中处理双向数据绑定变得更加容易，尤其是在需要将状态直接与 UI 组件连接时。

         用途
         @Bindable 允许将 ObservableObject 的属性作为 Binding，以便在视图中直接绑定并更新这些属性。
         它提高了代码的简洁性和可读性，使得在视图中使用 ObservableObject 更加直观。
         */
        @Bindable var modelData = modelData
        
        ScrollView {
            MapView(coordinate: landmark.locationCoordinate)
                .frame(height: 300)
            
            CircleImage(image: landmark.image)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name)
                        .font(.title)
                    FavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)
                }
                HStack{
                    Text(landmark.park)
                    Spacer()
                    Text(landmark.state)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Divider()
                
                Text("About \(landmark.name)")
                    .font(.title2)
                Text(landmark.description)
            }
            .padding()
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let modelData = ModelData()
    LandmarkDetail(landmark: modelData.landmarks[0])
        .environment(modelData)
}
