//
//  FindViwe.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 3/1/2022.
//

import SwiftUI
import MapKit

struct FindView: View {
    
    // anytime locationManager is  updated, the body will be re-rendered
//    @ObservedObject private var locationManager = LocationManager()
//    @State var currentLocation = CLLocationCoordinate2D()
    @EnvironmentObject var locationInfo: LocationInfo
    
    var body: some View {
        
        let distance = locationInfo.distance ?? 0.0
        let orientation = locationInfo.orientation ?? 0.0
        let currentLocation = locationInfo.currentLocation?.coordinate ?? CLLocationCoordinate2D()
        //let targetLocation = locationInfo.targetLocation?.coordinate ?? CLLocationCoordinate2D()
        
        VStack {
            
            Capsule()
                .frame(width: 5,
                       height: 50)
                .padding()
            
            Text("User: \(currentLocation.latitude), \(currentLocation.longitude)")
                .foregroundColor(Color.white)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
            
            Text("Distance: \(distance) meters" as String)
                .padding()
            
            Text("Orientation: \(orientation) degrees" as String)
        }

    }
    
}
