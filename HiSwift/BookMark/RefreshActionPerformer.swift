//
//  RefreshActionPerformer.swift
//  HelloSwift
//
//  Created by Bob on 2024/11/1.
//

import Foundation
import SwiftUI

class RefreshActionPerformer: ObservableObject{
    
    @Published private(set) var isPerforming = false
    
     func perform(_ action: RefreshAction) async {
        
        guard !isPerforming else {return}
        
        isPerforming = true
        await action()
        isPerforming = false
    }
}
