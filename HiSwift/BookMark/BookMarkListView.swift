//
//  BookMarkListView.swift
//  HelloSwift
//
//  Created by Bob on 2024/11/1.
//

import SwiftUICore
import SwiftUI

struct BookMarkListView : View{

    @ObservedObject var viewModel: BookMarkListModel
    @State private var error: Error?
    
    var body: some View {
        
        NavigationView {
            List{
                // 消除警告
                ForEach(0..<viewModel.bookmarks.count, id:\.self){ va in
                    Section(header: Text(viewModel.bookmarks[va])){
                        
                        ForEach(1..<5){ i in
                            Text("测试数据\(i)")
                        }
                    }
                }
            }
            .listStyle(.automatic)
            .navigationTitle("测试分组展示")
            .overlay(alignment: .top){
                if error != nil{
                    ErrorView(error: $error)
                }
            }
            .refreshable {
                do{
                    try await viewModel.reload()
                    error = nil
                } catch{
                    self.error = error
                }
            }
           
        }
      
    }
}
