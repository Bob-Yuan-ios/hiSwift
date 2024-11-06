//
//  PageView.swift
//  HiSwift
//
//  Created by Bob on 2024/11/6.
//

import SwiftUI

struct PageView<Page: View>: View {
    
    var pages: [Page]
    @State private var currentPage = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(pages: pages, currentPage: $currentPage)
            PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count * 58))
                .padding(.trailing)
        }
        .aspectRatio(3.0/2.0, contentMode: .fit)
    }
}

#Preview {
    PageView(pages: ModelData().features.map{
        FeatureCard(landmark: $0)
    })
}
