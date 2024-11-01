//
//  ContentView.swift
//  HiSwift
//
//  Created by Bob on 2024/10/31.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        VStack {
            MapView()
                .frame(height: 300)
            
            CircleImage()
                .offset(y: -130)
                .padding(.bottom, -130)
            
            
            VStack(alignment: .leading) {
                Text("Turtle Rock")
                    .font(.title)
                HStack{
                    Text("Joshua Tree National Park")
                    Spacer()
                    Text("Hello World")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Divider()
                
                Text("Hello")
                    .font(.title)
                Text("World")
                    .font(.title)
            }
        }
        .padding()
        
        Spacer()
    }
    
}

#Preview {
    ContentView()
}
