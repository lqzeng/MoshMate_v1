//
//  FindViwe.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 3/1/2022.
//

import SwiftUI
import MapKit

struct FindView: View {
    
    @EnvironmentObject var locationInfo: LocationInfo
    
    @Binding var selectedTab: String
    
    var body: some View {
        
        let distance = locationInfo.distance ?? 0.0
        let orientation = locationInfo.orientation ?? 0.0
        let currentLocation = locationInfo.currentLocation?.coordinate ?? CLLocationCoordinate2D()
        
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
        
        VStack {
            Arrow()
                .stroke(lineWidth: 15)
                .foregroundColor(.mint)
                .padding()
                .rotationEffect(.degrees(orientation))
                .onChange(of: orientation) { orientation in
                    if((orientation < 5 || orientation > 355) && selectedTab == "Two") {
                        feedbackGenerator.impactOccurred()
                    }
                }
            
            Text("User: \(currentLocation.latitude), \(currentLocation.longitude)")
                .foregroundColor(Color.white)
                .padding(.top)
                //.background(Color.green)
                .cornerRadius(10)
            
            Text("Distance: \(distance) meters" as String)
                .padding()
            
            Text("Orientation: \(orientation) degrees" as String)
            
            // stops bleed into tab bar
            Rectangle()
                 .frame(height: 0)
                 .background(.thinMaterial)
        }
        .background((orientation > 355 || orientation < 5) ? .green : .black)

    }
    
}

struct Arrow: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            path.addLines( [
                CGPoint(x: width * 0.4, y: height),
                CGPoint(x: width * 0.4, y: height * 0.4),
                CGPoint(x: width * 0.2, y: height * 0.4),
                CGPoint(x: width * 0.5, y: height * 0.1),
                CGPoint(x: width * 0.8, y: height * 0.4),
                CGPoint(x: width * 0.6, y: height * 0.4),
                CGPoint(x: width * 0.6, y: height)
            ] )
            
            path.closeSubpath()
        }
    }
}



