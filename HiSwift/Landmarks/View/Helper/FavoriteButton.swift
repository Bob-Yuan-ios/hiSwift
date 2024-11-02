//
//  FavoriteButton.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//

import SwiftUI

struct FavoriteButton: View {
    
    /*
     @Binding 是 SwiftUI 中的一个属性包装器，用于在视图之间创建双向数据绑定。
     它允许子视图修改父视图中的状态，同时确保这些变化能够反映到父视图中。
     这在构建复杂的用户界面时非常有用，因为它简化了数据传递和状态管理。
     */
    @Binding var isSet: Bool
    
    var body: some View {

        Button{
            // 切换bool变量值
            isSet.toggle()
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(isSet ? .yellow : .gray)
        }
    }
}

#Preview {
    FavoriteButton(isSet: .constant(true))
}
