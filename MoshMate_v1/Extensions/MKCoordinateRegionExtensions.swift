//
//  MKCoordinateRegionExtensions.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 5/1/2022.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    
    enum MapDetails {
        static let startingLocation = CLLocationCoordinate2D(latitude: -37.837148,
                                                             longitude: 144.990249)
        static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.005,
                                                  longitudeDelta: 0.005)
    }
    
    static var defaultRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    }
    
}
