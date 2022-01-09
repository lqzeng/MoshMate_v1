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
    //@EnvironmentObject var annotationInfo: AnnotationInfo

    @Binding var locationManager: CLLocationManager
    @Binding var degrees: Double?
    @Binding var currentLocation: CLLocation?
    @Binding var targetLocation: CLLocation?
    
    // vars for alert to name location
    @Binding var showingAlert: Bool
    @Binding var locationName: String
    @Binding var addAnnotation: Bool
    
    var annotationInfo = AnnotationInfo(title: "title", coordinate: CLLocationCoordinate2D())
    
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
        Coordinator(self, degrees ?? 0.0, currentLocation, targetLocation, showingAlert)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
        
        var parent: MapUIView
        var degrees: Double?
        var currentLocation: CLLocation?
        var targetLocation: CLLocation?
        var showingAlert: Bool
        
        init(_ parent: MapUIView, _ degrees: Double, _ currentLocation: CLLocation?, _ targetLocation: CLLocation?, _ showingAlert: Bool){
            self.parent = parent
            self.degrees = degrees
            self.currentLocation = currentLocation
            self.targetLocation = targetLocation
            self.showingAlert = showingAlert
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
                
                addAnnotation(gesture: gesture)
                
                // run text alert to name location
                //alert(gesture: gesture)
                    
            }

            
        }
        
        @objc func handleTap(sender: UITapGestureRecognizer){
            
            // handle tap gesture
            
            
        }
        
        func addAnnotation(gesture: UIGestureRecognizer)
        {
            
            // feed in information from handle press
            if let mapView = gesture.view as? MKMapView {
                let point = gesture.location(in: mapView)

                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate

                annotation.title = "newLocation"
                mapView.addAnnotation(annotation)
                
                //mapView.removeAnnotations(self.parent.mapView.annotations)
                //mapView.addAnnotation(annotation)

                //parent.addAnnotation = false
            }
        }

        
        private func alert(gesture:UIGestureRecognizer) {
            
            // this alert will throw a textbox up
            
            let alert = UIAlertController(title: "Enter a location name: ", message: "", preferredStyle: .alert)
            alert.addTextField() { textField in
                textField.placeholder = "Enter some text"
                textField.keyboardType = UIKeyboardType.asciiCapable
            }
            
            alert.addAction(UIAlertAction(title: "Save", style: .default) { action in
                if let textField = alert.textFields?[0], let text = textField.text {
                    // do something with text
                    self.parent.locationName = text
                } else {
                    // Didn't get text
                }
            })
            
            showAlert(alert: alert)
            
            // update annotationInfo with title and coordinate to be added as annotation
            
            if let mapView = gesture.view as? MKMapView {
                let point = gesture.location(in: mapView)

                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                
                annotation.title = parent.locationName
                
                
                parent.locationInfo.annotationCoordinate = annotation.coordinate
                parent.locationInfo.annotationTitle = annotation.title
                
                // set this to true which will trigger add annotation
                //parent.addAnnotation = true
                
                
                mapView.addAnnotation(annotation)
            }
            
            //alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
            
            
            // now toggle off
            //showingAlert = false
            
        }

        func showAlert(alert: UIAlertController) {
            if let controller = topMostViewController() {
                controller.present(alert, animated: true)
            }
        }

        private func keyWindow() -> UIWindow? {
            return UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .compactMap {$0 as? UIWindowScene}
            .first?.windows.filter {$0.isKeyWindow}.first
        }

        private func topMostViewController() -> UIViewController? {
            guard let rootController = keyWindow()?.rootViewController else {
                return nil
            }
            return topMostViewController(for: rootController)
        }

        private func topMostViewController(for controller: UIViewController) -> UIViewController {
            if let presentedController = controller.presentedViewController {
                return topMostViewController(for: presentedController)
            } else if let navigationController = controller as? UINavigationController {
                guard let topController = navigationController.topViewController else {
                    return navigationController
                }
                return topMostViewController(for: topController)
            } else if let tabController = controller as? UITabBarController {
                guard let topController = tabController.selectedViewController else {
                    return tabController
                }
                return topMostViewController(for: topController)
            }
            return controller
        }
        
        
    }
    

    
}
