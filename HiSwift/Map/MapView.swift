//
//  MapView.swift
//  HiSwift
//
//  Created by Bob on 2024/11/1.
//

import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
        Map(initialPosition: .region(region))
    }
    
    
    private var region: MKCoordinateRegion{
        
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 34.011_286, longitude:  -116.166_868), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
    }
}

#Preview {
    MapView()
}
