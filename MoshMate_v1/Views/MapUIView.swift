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
    
    let mapView = MKMapView()
    
    var hasSetRegion = false
    
    func makeUIView(context: Context) -> MKMapView {
        
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        
        // location stuff
        locationManager.delegate = context.coordinator
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        
        
        // LongPressGesture
        let uilgr = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePress(gesture:)))
        uilgr.minimumPressDuration = 0.5

        mapView.addGestureRecognizer(uilgr)
        
        // tapGesture
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap))
        
        tapGesture.delegate = context.coordinator
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
            
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
        
        // --- location manager delegates ---
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            // only interested in the last location
            guard let location = locations.last else { return }
            
            if !parent.hasSetRegion {
                parent.mapView.region = MKCoordinateRegion(center: location.coordinate,
                                                 span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                parent.hasSetRegion = true
            }
            
            // check if this var is needed
            parent.currentLocation = location
            
            parent.locationInfo.currentLocation = location
                
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
        
        // --- annotationView delegates
        
        // delete if not used
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // do something
            return nil
        }
        
        // delegate function to listen for annotation selection on map
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
            // select an annotation, then calculate the target distance
            
            //let annotation = view.annotation!
            
            // remove single or all of annotation
            //mapView.removeAnnotations(self.parent.mapView.annotations)
            //mapView.removeAnnotation(annotation)
                
            let coordinate = view.annotation?.coordinate ?? CLLocationCoordinate2D()

            // set targetLocation to the selected annotation coordinates
            parent.targetLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            parent.locationInfo.targetLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            print("targetLocation changed")
            
            // calculate distance to target
            
            parent.locationInfo.distance = returnDistance(location1: parent.currentLocation ?? CLLocation(latitude: 0, longitude: 0), location2: parent.targetLocation ?? CLLocation(latitude: 0, longitude: 0))

        }
        
        // --- functions to calculate distance and orientation ---
        
        func returnDistance(location1: CLLocation, location2: CLLocation) -> Double{
            
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
            
            return theta
        }
        
        // --- gesture recognisers
        
        @objc func handlePress(gesture: UIGestureRecognizer) {
            
            print("inside handlepress")
            
            if gesture.state == .ended {
                
                // run text alert to name location
                
                let mapView = gesture.view as? MKMapView
                let point = gesture.location(in: mapView)
                alertViewAddAnnotation(gesture: gesture, point: point)
                    
            }
            
        }
        
        @objc func handleTap(gesture: UITapGestureRecognizer){
            
            // handle tap gesture
            //alert(gesture:gesture)
            
            
        }
        
        func addAnnotation(gesture: UIGestureRecognizer, point: CGPoint, annName: String)
        {
            
            if let mapView = gesture.view as? MKMapView {
                let point = point

                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                
                annotation.title = annName
                mapView.addAnnotation(annotation)
                
                
                
                //mapView.removeAnnotations(self.parent.mapView.annotations)
                //mapView.addAnnotation(annotation)

            }
        }
        
        func alertViewAddAnnotation(gesture: UIGestureRecognizer, point: CGPoint) {
            let alert = UIAlertController(title: "Save Location", message: "Enter a Location Name", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.placeholder = "Tent"
                textField.keyboardType = UIKeyboardType.asciiCapable
            }
            
            
            // Action Buttons
            
            let save = UIAlertAction(title: "Save", style: .default) {
                (_) in
                
                // save the annotation name and add the annotation
                
                let annName = alert.textFields![0].text!
                
                self.addAnnotation(gesture: gesture, point: point, annName: annName)
                
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive) {
                (_) in
                // do your own stuff
            }
            
            // add into alertView
            
            alert.addAction(save)
            alert.addAction(cancel)
            
            // presenting alertView
            
            UIApplication.shared.currentUIWindow()?.rootViewController?.present(alert, animated: true, completion: {
                // do something here
                
                // see extension
                
            })
            
        }
        
        
    }

    
}

public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter({
                $0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
    }
}
