//
//  CategoryItem.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//

import SwiftUI

struct CategoryItem: View {
    
    var landmark: Landmark
    var body: some View {
        
        VStack(alignment: .leading) {
            landmark.image
                .resizable()
                .frame(width: 120, height: 120)
                .cornerRadius(5)
            
            Text(landmark.name)
                .foregroundStyle(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

#Preview {
    CategoryItem(landmark: ModelData().landmarks[0])
}
