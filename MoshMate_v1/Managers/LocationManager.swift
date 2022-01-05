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
    
    var locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    
    @Published var degrees: Double = .zero
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestAlwaysAuthorization()
        //self.locationManager.startUpdatingLocation()
        //self.locationManager.startUpdatingHeading()
        
        print("Finished initialising Location Manager")
    }
    

    func returnDistance(location1: CLLocationCoordinate2D, location2: CLLocationCoordinate2D) -> Double{
           let loc1: CLLocation = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
           let loc2: CLLocation = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
           
           let distance: CLLocationDistance = loc1.distance(from: loc2)
           //print(distance)
           return distance
    }
    
    // dummy function to get target coordinates
    func getTargetCoordinates() -> (CLLocationCoordinate2D) {
        // for now this is returning somewhere in fawknerpark
        return (CLLocationCoordinate2D(latitude: -37.839148,
                                       longitude: 144.980249))
    }
    
    // function to calculate angle between true north and your target
    func getBearing(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {

        let lat1 = point1.latitude * .pi / 180
        let lon1 = point1.longitude * .pi / 180

        let lat2 = point2.latitude * .pi / 180
        let lon2 = point2.longitude * .pi / 180

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)

        var radiansBearing = atan2(y, x)
        if radiansBearing < 0 {
            radiansBearing += 2 * Double.pi
        }

        return radiansBearing * 180 / .pi
    }
    
    // Compute the angle between two map points and the from point heading
    // returned angle is between 0 and 360 degrees
    
    func doComputeAngleBetweenMapPoints(
        fromHeading: CLLocationDirection,
        _ fromPoint: CLLocationCoordinate2D,
        _ toPoint: CLLocationCoordinate2D
    ) -> CLLocationDirection {
        let bearing = getBearing(point1: fromPoint, point2: toPoint)
        var theta = bearing - fromHeading
        if theta < 0 {
            theta += 360
        }
        //print(theta)
        return theta
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    // implement did update locations and update headings
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // only interested in the last location
        guard let location = locations.last else { return }
        
        self.location = location
        //print("updated location")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.degrees = newHeading.magneticHeading
        //print("updated heading")
    }
    
    // check for changing of authorisation at any point
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        // check for enabled Location Services
        
        let locationManager = locationManager
                
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            case .restricted:
                print("Your location is restricted. Check parental controls")
            case .denied:
                print("App location permission is denied")
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationManager.startUpdatingLocation()
                self.locationManager.startUpdatingHeading()
                print("Authorised. Location and Heading Updating")
            @unknown default:
                break
                
        }
    }
    
}

