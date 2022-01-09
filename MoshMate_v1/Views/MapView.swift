//
//  MapView.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 6/1/2022.
//

import SwiftUI
import MapKit

//struct Location: Identifiable {
//    let id = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//}

struct MapView: View {
    
   
    //@EnvironmentObject var annotationInfo: AnnotationInfo
    
    @State var locationManager = CLLocationManager()
    @State var degrees: Double?
    @State var currentLocation: CLLocation?
    @State var targetLocation: CLLocation?
    
    @State var randomLocation = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
    
    @State var showingAlert: Bool = false
    @State var locationName: String = ""
    @State var addAnnotation: Bool = true
   
    var body: some View {
        
        //let locationName = annotationInfo.name

        VStack {
            
            MapUIView(locationManager: $locationManager, degrees: $degrees, currentLocation: $currentLocation, targetLocation: $targetLocation, showingAlert: self.$showingAlert, locationName: $locationName, addAnnotation: $addAnnotation)
                .edgesIgnoringSafeArea(.top)
//                .onChange(of: showingAlert) {
//                    value in
//                    guard value else {return} // if value of showingAlert is not true, then do nothing
//                    alert() // code hits here if true
//
//                    // might need to set up thing here to add annotation
//
//                }
            }
    }
    
    
    
//    private func alert() {
//
//        let alert = UIAlertController(title: "Enter a location name: ", message: "", preferredStyle: .alert)
//        alert.addTextField() { textField in
//            textField.placeholder = "Enter some text"
//            textField.keyboardType = UIKeyboardType.asciiCapable
//        }
//
//        alert.addAction(UIAlertAction(title: "Save", style: .default) { action in
//            if let textField = alert.textFields?[0], let text = textField.text {
//                // do something with text
//                locationName = text
//            } else {
//                // Didn't get text
//            }
//        })
//        //alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
//        showAlert(alert: alert)
//
//        // now toggle off
//        showingAlert = false
//    }
//
//    func showAlert(alert: UIAlertController) {
//        if let controller = topMostViewController() {
//            controller.present(alert, animated: true)
//        }
//    }
//
//    private func keyWindow() -> UIWindow? {
//        return UIApplication.shared.connectedScenes
//        .filter {$0.activationState == .foregroundActive}
//        .compactMap {$0 as? UIWindowScene}
//        .first?.windows.filter {$0.isKeyWindow}.first
//    }
//
//    private func topMostViewController() -> UIViewController? {
//        guard let rootController = keyWindow()?.rootViewController else {
//            return nil
//        }
//        return topMostViewController(for: rootController)
//    }
//
//    private func topMostViewController(for controller: UIViewController) -> UIViewController {
//        if let presentedController = controller.presentedViewController {
//            return topMostViewController(for: presentedController)
//        } else if let navigationController = controller as? UINavigationController {
//            guard let topController = navigationController.topViewController else {
//                return navigationController
//            }
//            return topMostViewController(for: topController)
//        } else if let tabController = controller as? UITabBarController {
//            guard let topController = tabController.selectedViewController else {
//                return tabController
//            }
//            return topMostViewController(for: topController)
//        }
//        return controller
//    }
    
}

