//
//  ContentView.swift
//  HiSwift
//
//  Created by Bob on 2024/10/31.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello SwiftUI!")
                .font(.title)
                .foregroundColor(.green)
            HStack {
                Text("约书亚树国家公园")
                    .font(.subheadline)
                Spacer()
                Text("Hello World")
                    .font(.subheadline)
            }
        }
        .padding()
    }
    
}

#Preview {
    ContentView()
}
