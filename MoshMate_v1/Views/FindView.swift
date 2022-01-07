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
    @ObservedObject private var locationManager = LocationManager()
    @State var currentLocation = CLLocationCoordinate2D()
    
    var body: some View {
        
        let userCoordinates = self.locationManager.location != nil ?
            self.locationManager.location!.coordinate :
            CLLocationCoordinate2D()

        let distance = locationManager.returnDistance(location1: userCoordinates, location2: locationManager.getTargetCoordinates())

        let orientation: Double = locationManager.doComputeAngleBetweenMapPoints(fromHeading: locationManager.degrees, userCoordinates, locationManager.getTargetCoordinates())

        ScrollView {
            Text("User Coordinates: \(userCoordinates.latitude), \(userCoordinates.longitude)")
                .foregroundColor(Color.white)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
            Text("Distance to Fawkner: \(distance) metres")
                .padding()
            Text("Orientation to Fawkner: \(orientation) degrees")
        }
    }
    
}

struct FindView_Previews: PreviewProvider {
    static var previews: some View {
        FindView()
    }
}
