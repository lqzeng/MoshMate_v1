//
//  MapView.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 5/1/2022.
//

import MapKit
import SwiftUI

struct MapUIView: UIViewRepresentable {
    
    @EnvironmentObject var locationInfo: LocationInfo

    @Binding var locationManager: CLLocationManager
    @Binding var degrees: Double?
    @Binding var currentLocation: CLLocation?
    @Binding var targetLocation: CLLocation?
    
    @State var counter = 0
    
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        
        mapView.showsUserLocation = true
        
        // use this for gestures
        mapView.delegate = context.coordinator
        
        // LongPressGesture
        let uilgr = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.addAnnotation(gesture:)))
        uilgr.minimumPressDuration = 0.5

        mapView.addGestureRecognizer(uilgr)
        
        // tapGesture
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap))
        
        tapGesture.delegate = context.coordinator
        mapView.addGestureRecognizer(tapGesture)
        
        // location stuff
        locationManager.delegate = context.coordinator
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {

//        if annotations.count != view.annotations.count {
//            print("inside updateUIView")
//            view.removeAnnotations(view.annotations)
//            view.addAnnotations(annotations)
//        }
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self, degrees ?? 0.0, currentLocation, targetLocation)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
        
        var parent: MapUIView
        var degrees: Double?
        var currentLocation: CLLocation?
        var targetLocation: CLLocation?
        
        init(_ parent: MapUIView, _ degrees: Double, _ currentLocation: CLLocation?, _ targetLocation: CLLocation?){
            self.parent = parent
            self.degrees = degrees
            self.currentLocation = currentLocation
            self.targetLocation = targetLocation
        }
        
        // location manager delegates
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            // only interested in the last location
            guard let location = locations.last else { return }
            
            // set region to current location
            parent.mapView.setRegion(MKCoordinateRegion(center: location.coordinate,
                                                        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: false)
            
            // check if this var is needed
            parent.currentLocation = location
            
            parent.locationInfo.currentLocation = location
            
            // calculate distance
            
            parent.locationInfo.distance = returnDistance(location1: location, location2: parent.targetLocation ?? CLLocation(latitude: 0, longitude: 0))
        
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
            parent.degrees = newHeading.magneticHeading
            //print("updated heading")
            
            // calculate orientation
            parent.locationInfo.orientation = doComputeAngleBetweenMapPoints(fromHeading: parent.degrees ?? 0.0, parent.currentLocation?.coordinate ?? CLLocationCoordinate2D(), parent.targetLocation?.coordinate ?? CLLocationCoordinate2D())

        }
        
        // check for changing of authorisation at any point
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            
            let locationManager = self.parent.locationManager
            
            // check for enabled Location Services
                    
                switch locationManager.authorizationStatus {
                case .notDetermined:
                    locationManager.requestAlwaysAuthorization()
                case .restricted:
                    print("Your location is restricted. Check parental controls")
                case .denied:
                    print("App location permission is denied")
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Authorised.")
                @unknown default:
                    break
            }
        }
        
        // --- functions to calculate distance and orientation ---
        
        func returnDistance(location1: CLLocation, location2: CLLocation) -> Double{
//
               let distance: CLLocationDistance = location1.distance(from: location2)
               return distance
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
        
        // gesture recognisers
        
        @objc func addAnnotation(gesture: UIGestureRecognizer) {

                if gesture.state == .ended {

                if let mapView = gesture.view as? MKMapView {
                    let point = gesture.location(in: mapView)
                    
                    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "TargetLocation"
                    mapView.removeAnnotations(self.parent.mapView.annotations)
                    mapView.addAnnotation(annotation)
                    
                    // apply this to the target location var
                    parent.targetLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    parent.locationInfo.targetLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    //print(parent.targetLocation?.coordinate ?? CLLocation(latitude: 0, longitude: 0))
                }
            }
        }
        
        @objc func handleTap(sender: UITapGestureRecognizer){
            print("tap gesture recognised")
        }
        
        
    }
    
}
