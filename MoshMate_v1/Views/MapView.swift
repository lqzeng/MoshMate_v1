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
    
    @State var showingAlert: Bool = false
    @State var locationName: String = ""
    @State var addAnnotation: Bool = true
   
    var body: some View {
        
        //let locationName = annotationInfo.name

        VStack {
            
            MapUIView(locationManager: $locationManager, degrees: $degrees, currentLocation: $currentLocation, targetLocation: $targetLocation, showingAlert: self.$showingAlert, locationName: $locationName, addAnnotation: $addAnnotation)
                .edgesIgnoringSafeArea(.top)
//                .onChange(of: addAnnotation) {
//                    value in
//                    guard value else {return} // if value of showingAlert is not true, then do nothing
//                    print("insideOnChange")// code hits here if true

                    // might need to set up thing here to add annotation

                }
            
    }
    
    
}

