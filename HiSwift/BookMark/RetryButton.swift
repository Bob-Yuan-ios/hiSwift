//
//  RetryButton.swift
//  HelloSwift
//
//  Created by Bob on 2024/11/1.
//  

import SwiftUICore
import SwiftUI

struct RetryButton: View{
    
    var title: LocalizedStringKey = "Retry"
    
    @Environment(\.refresh) private var action
    @StateObject private var actionPerformer = RefreshActionPerformer()
    
    var body: some View {
        if let action = action {
            Button(
                role: nil,
                action: {
                    Task{
                        await actionPerformer.perform(action)
                    }
                },
                label: {
                    ZStack{
                        if actionPerformer.isPerforming{
                            Text(title).hidden()
                            ProgressView()
                        }else{
                            Text(title)
                        }
                    }
                }
            )
            .disabled(actionPerformer.isPerforming)
        }
    }
}
