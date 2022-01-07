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
    
    var body: some Scene {
        WindowGroup {
            TabView {
//                NavigationView{
//                    StackedView()
//                }
//                .tabItem{
//                    Image(systemName: "location.north.line.fill")
//                    Text("Stacked View")
//                }
                    
                NavigationView{
                    FindView()
                }
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Find My Mate")
                }
                NavigationView{
                    MapView()
                }
                .tabItem{
                    Image(systemName: "airplane.circle.fill")
                    Text("Locations")
                }
            }
        }
    }
}
