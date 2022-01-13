//
//  MapView.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 6/1/2022.
//

import SwiftUI
import MapKit

//struct Location: Identifiable {
//    let id = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//}

struct MapView: View {
    
   
    @EnvironmentObject var locationInfo: LocationInfo
    
    @State var locationManager = CLLocationManager()
    @State var degrees: Double?
    @State var currentLocation: CLLocation?
    @State var targetLocation: CLLocation?
    
    @State var randomLocation = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
   
    var body: some View {
        
        //let locationName = annotationInfo.name

        VStack {
            
            MapUIView(locationManager: $locationManager, degrees: $degrees, currentLocation: $currentLocation, targetLocation: $targetLocation)
                .edgesIgnoringSafeArea(.top)
                }
            
    }
    

    
    
}

