//
//  StackedView.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 5/1/2022.
//

import SwiftUI
import MapKit

struct StackedView: View {
    
    @ObservedObject private var locationManager = LocationManager()
    
    @State private var locations = [MKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    
    var body: some View {
       
        VStack{
            
            //Instead of map this will be an arrow compass thing
            
//            MapUIView(selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
//                .ignoresSafeArea()
            
            //FindView()
            
        }
        
    }
}

struct StackedView_Previews: PreviewProvider {
    static var previews: some View {
        StackedView()
    }
}
