//
//  MapView.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 6/1/2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State var locationManager = CLLocationManager()
    @State var degrees: Double?
    @State var currentLocation: CLLocation?
    @State var targetLocation: CLLocation?
    
        var body: some View {
            
            let current = currentLocation?.coordinate
            let target = targetLocation?.coordinate
            
            VStack {
                MapUIView(locationManager: $locationManager, degrees: $degrees, currentLocation: $currentLocation, targetLocation: $targetLocation)
                    .ignoresSafeArea()
                //Text("\(targetLocation ?? CLLocation(latitude: 0, longitude: 0))")
                Text("CurrentLocation: \(current)" as String)
                    .padding(.bottom)
                Text("TargetLocation: \(target)" as String)
            }

                
    }
    
}

