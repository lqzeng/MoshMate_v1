//
//  LocationViewModel.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 3/1/2022.
//

import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: -37.837148,
                                                         longitude: 144.990249)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.005,
                                              longitudeDelta: 0.005)
}

final class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // whenever this region changes, our UI will update
    @Published var region = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.defaultSpan
    )
    
    var degrees: Double = .zero {
        willSet {
            objectWillChange.send()
        }
    }
    
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            // create location manager. this will automatically call didchangeauth
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            
            // set accuracy and orentation
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
            locationManager?.startUpdatingHeading()
            
            
        } else {
            print ("Show an alert prompting enable location services")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation], didUpdateHeading newHeading: CLHeading) {
        checkLocationAuthorisation()
        self.degrees = -1 * newHeading.magneticHeading
        
        if currentLocation == nil {
            currentLocation = locations.last
        }
    }
    
    
    func checkLocationAuthorisation() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            print("Your location is restricted. Check parental controls")
        case .denied:
            print("App location permission is denied")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: MapDetails.startingLocation,
                                        span: MapDetails.defaultSpan)
        @unknown default:
            break
        }
    }
    
//    // basically the delegate method for CLlocationManager
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkLocationAuthorisation()
//    }
    
    ///
    ///
    ///
    
    func getUserCoordinates() -> (CLLocationCoordinate2D) {
        // check this forceunwrap later if it is safe
        //  print (locationManager?.location?.coordinate)
        //return (locationManager?.location?.coordinate)
        return(region.center)
    }
    
    func getTargetCoordinates() -> (CLLocationCoordinate2D) {
        // for now this is returning somewhere in fawknerpark
        return (CLLocationCoordinate2D(latitude: -37.839148,
                                       longitude: 144.980249))
    }
    
    // return distance between location 1 and location 2
    
    
    func returnDistance(location1: CLLocationCoordinate2D, location2: CLLocationCoordinate2D) -> Double{
        let loc1: CLLocation = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
        let loc2: CLLocation = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
        
        let distance: CLLocationDistance = loc1.distance(from: loc2)
        print(distance)
        return distance
    }
    
    // function to calculate angle between true north and your target
    func getBearing(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {

        let lat1 = point1.latitude * 180 / .pi
        let lon1 = point1.longitude * 180 / .pi

        let lat2 = point2.latitude * 180 / .pi
        let lon2 = point2.longitude * 180 / .pi

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)

        var radiansBearing = atan2(y, x)
        if radiansBearing < 0 {
            radiansBearing += 2 * Double.pi
        }

        return radiansBearing * .pi / 180
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
        print(theta)
        return theta
    }
}
