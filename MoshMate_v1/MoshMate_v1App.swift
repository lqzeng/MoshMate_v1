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
    let minDragTranslationForSwipe: CGFloat = 50
    
    var body: some Scene {
        WindowGroup {
            
            TabView(selection: $selectedTab) {
                MapUIView(locationManager: $locationManager, degrees: $degrees, currentLocation: $currentLocation, targetLocation: $targetLocation, selectedTab: $selectedTab)
                    .edgesIgnoringSafeArea(.top)
                    //.ignoresSafeArea()
                    .tabItem {
                        Label("Locations", systemImage: "airplane.circle.fill")
                    }
                    .tag("One")
                    .highPriorityGesture(DragGesture().onEnded({ self.handleSwipe(translation: $0.translation.width)}))

                FindView(selectedTab: $selectedTab)
                    .tabItem {
                        Label("Find My Mate", systemImage: "star.fill")
                    }
                    .tag("Two")
                    .highPriorityGesture(DragGesture().onEnded({ self.handleSwipe(translation: $0.translation.width)}))

            }
            .environmentObject(locationInfo)
        }
    }
    
    private func handleSwipe(translation: CGFloat) {
        if translation > minDragTranslationForSwipe && selectedTab == "Two" {
            selectedTab = "One"
            //  } else  if translation < -minDragTranslationForSwipe && selectedTab == "One" {
            //  selectedTab = "Two"
        }
    }
}
