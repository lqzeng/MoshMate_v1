//
//  LocationView.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 3/1/2022.
//

import MapKit
import SwiftUI

struct LocationView: View {
    
    @StateObject private var viewModel = LocationViewModel()
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onAppear{
                viewModel.checkIfLocationServicesIsEnabled()
            }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}


