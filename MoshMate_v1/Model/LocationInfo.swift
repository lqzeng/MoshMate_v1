//
//  LocationInfo.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 7/1/2022.
//

import Foundation
import CoreLocation

class LocationInfo: ObservableObject {
    

    @Published var currentLocation: CLLocation? = nil
    @Published var targetLocation: CLLocation? = nil
    @Published var degrees: Double? = 0.0
    @Published var distance: Double? = 0.0
    @Published var orientation: Double? = 0.0
    
    init() {
        print("initialising LocationInfo object")
    }
}
