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
    
    var body: some Scene {
        WindowGroup {
            TabView {
                
                NavigationView{
                    MapView()
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
            //.environmentObject(annotationInfo)
        }
    }
}
