//
//  MoshMate_v1App.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 3/1/2022.
//

import SwiftUI

@main
struct MoshMate_v1App: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView{
                    FindView()
                }
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Find My Mate")
                }
            
                NavigationView{
                    LocationView()
                }
                .tabItem{
                    Image(systemName: "airplane.circle.fill")
                    Text("Locations")
                }
            }
        }
    }
}
