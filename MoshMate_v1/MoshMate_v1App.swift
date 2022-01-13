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
    
    @State var selectedTab = "One"
    
    var body: some Scene {
        WindowGroup {
            
            TabView(selection: $selectedTab) {
                MapUIView(locationManager: $locationManager, degrees: $degrees, currentLocation: $currentLocation, targetLocation: $targetLocation, selectedTab: $selectedTab)
                        .edgesIgnoringSafeArea(.top)
                    .tabItem {
                        Label("Locations", systemImage: "airplane.circle.fill")
                    }
                    .tag("One")

                FindView()
                    .tabItem {
                        Label("Find My Mate", systemImage: "star.fill")
                    }
                    .tag("Two")
            }
            
//            TabView {
//
//                NavigationView{
//                    if !showFindView{
//                        MapUIView(locationManager: $locationManager, degrees: $degrees, currentLocation: $currentLocation, targetLocation: $targetLocation, showFindView: $showFindView)
//                            .edgesIgnoringSafeArea(.top)
//                    }
//                    else {
//                        FindView()
//                            .transition(.move(edge:.bottom))
//                    }
//
//                }
//                .tabItem{
//                    Image(systemName: "airplane.circle.fill")
//                    Text("Locations")
//                }
//
//                NavigationView{
//                    FindView()
//                }
//                .tabItem {
//                    Image(systemName: "star.fill")
//                    Text("Find Target")
//                }
//            }
            .environmentObject(locationInfo)
        }
    }
}
