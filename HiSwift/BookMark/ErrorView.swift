//
//  ErrorView.swift
//  HelloSwift
//
//  Created by Bob on 2024/11/1.
//

import SwiftUICore
import SwiftUI

struct ErrorView: View {
    
    @Binding var error: Error?
    var body: some View {
        
        if let error = error{
            
            VStack{
                Text(error.localizedDescription)
                    .bold()
                HStack{
                    Button("Dismiss"){
                        self.error = nil
                    }
                    RetryButton()
                }
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
