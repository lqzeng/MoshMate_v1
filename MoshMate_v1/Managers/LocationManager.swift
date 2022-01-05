//
//  LocationManager.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 5/1/2022.
//

import Foundation
import MapKit

// needs to be observable so location can be updated constantly

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    // implement did update locations
    func locationMananger(_ manager: CLLocationManager, didUpdateLocation locations: [CLLocation]) {
        
        // only interested in the last location
        guard let location = locations.last else { return }
        
        self.location = location
    }
    
    
}
