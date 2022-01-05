//
//  MapView.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 5/1/2022.
//

import MapKit
import SwiftUI

struct MapView: View {
    
    @State private var region = MKCoordinateRegion.defaultRegion
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
    }
}
