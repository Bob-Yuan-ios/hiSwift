//
//  ProfileSummary.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//

import SwiftUI

struct ProfileSummary: View {
    
    @Environment(ModelData.self) var modelData
    var profile: Profile
    var body: some View {
        
        ScrollView{
            
            VStack(alignment: .leading, spacing: 10) {
                Text(profile.username)
                    .bold()
                    .font(.title)
                
                Text("Notifications: \(profile.prefersNotifications ? "On": "Off" )")
                Text("Seasonal Photos: \(profile.seasonalPhoto.rawValue)")
                Text("Goal Date: ") + Text(profile.goalDate, style: .date)
                
                Divider()
                
                VStack(alignment: .leading) {
                    
                    Text("Complete Badges")
                        .font(.headline)
                    
                    ScrollView(.horizontal){
                        HStack{
                            HikeBadge(name: "First")
                            
                            HikeBadge(name: "Second")
                                .hueRotation(Angle(degrees: 90))
                            
                            HikeBadge(name: "Third")
                                .grayscale(0.5)
                                .hueRotation(Angle(degrees: 45))
                            
                        }
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Recent Hikes")
                        .font(.headline)
                        
                    HikeView(hike: modelData.hikes[0])
                }
            }
            .padding(.leading)
        }
    }
}

#Preview {
    ProfileSummary(profile: Profile.default)
        .environment(ModelData())
}
