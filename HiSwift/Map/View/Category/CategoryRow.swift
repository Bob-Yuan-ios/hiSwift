//
//  CategoryRow.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//

import SwiftUI

struct CategoryRow: View {
    
    var categoryName: String
    var items:[Landmark]
    
    var body: some View {
        VStack(alignment: .leading){
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 15)

            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .bottom, spacing: 15) {
                    ForEach(items){ landmark in
                        NavigationLink{
                            LandmarkDetail(landmark: landmark)
                        } label: {
                            CategoryItem(landmark: landmark)
                        }
                    }
                }
            }
            .frame(height: 150)
       
        }
    }
}

#Preview {
    let landmark = ModelData().landmarks
    return CategoryRow(
        categoryName: landmark[0].category.rawValue,
        items: Array(landmark.prefix(4))
    )
}
