//
//  ContentView.swift
//  HelloSwift
//
//  Created by Bob on 2024/10/31.
//

import SwiftUI


struct ContentView: View {
    @State private var fruits = [
        "Apple",
        "Banana",
        "Orange"
    ]

    func setListSection() -> some View {
        NavigationView {
            List{
                // 消除警告
                ForEach(0..<fruits.count, id:\.self){ va in
                 
                    Section(header: Text(fruits[va])){
                        
                        ForEach(1..<5){ i in
                            Text("测试数据\(i)")
                        }
                    }
                }
            }
            .listStyle(.automatic)
            .navigationTitle("测试分组展示")
        }
    }
    
    var body: some View {
        setListSection()
    }
    
  
}

#Preview {
    ContentView()
}
