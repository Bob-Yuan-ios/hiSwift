//
//  ProfileHost.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//

import SwiftUI

struct ProfileHost: View {
    
    @State private var draftProfile = Profile.default
    var body: some View {
       
        VStack(alignment: .leading, spacing: 20) {
            ProfileSummary(profile: draftProfile)
        }
    }
}

#Preview {
    ProfileHost()
}
