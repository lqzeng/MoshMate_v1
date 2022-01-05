//
//  FindViwe.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 3/1/2022.
//

import SwiftUI
import MapKit

struct FindView: View {
    
    @ObservedObject private var viewModel = LocationViewModel()
    
    var body: some View {
        
//        let location1 = CLLocationCoordinate2D(latitude: (viewModel.currentLocation?.coordinate.latitude)!, longitude: (viewModel.currentLocation?.coordinate.longitude)!)

        let distance : Int = Int(viewModel.returnDistance(location1: viewModel.getUserCoordinates(), location2: viewModel.getTargetCoordinates()))


        let orientation: Double = viewModel.doComputeAngleBetweenMapPoints(fromHeading: viewModel.degrees, viewModel.getUserCoordinates(), viewModel.getTargetCoordinates())

        ScrollView {
            Text("Distance to target: ")
                .font(.title)
            Text("\(distance) metres")
                .padding(.bottom)
            Text("Orientation to target:")
                .font(.title)
            Text("\(orientation) degrees")
        }
    }
}

struct FindView_Previews: PreviewProvider {
    static var previews: some View {
        FindView()
    }
}
