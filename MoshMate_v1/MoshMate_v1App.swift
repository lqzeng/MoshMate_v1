//
//  MoshMate_v1App.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 3/1/2022.
//

import SwiftUI
import MapKit

@main
struct MoshMate_v1App: App {
    
    @StateObject var locationInfo = LocationInfo()
    
    @State var locationManager = CLLocationManager()
    @State var degrees: Double?
    @State var currentLocation: CLLocation?
    @State var targetLocation: CLLocation?
    
    var body: some Scene {
        WindowGroup {
            TabView {
                
                NavigationView{
                    MapUIView(locationManager: $locationManager, degrees: $degrees, currentLocation: $currentLocation, targetLocation: $targetLocation)
                        .edgesIgnoringSafeArea(.top)
                }
                .tabItem{
                    Image(systemName: "airplane.circle.fill")
                    Text("Locations")
                }
                    
                NavigationView{
                    FindView()
                }
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Find Target")
                }
            }
            .environmentObject(locationInfo)
        }
    }
}
