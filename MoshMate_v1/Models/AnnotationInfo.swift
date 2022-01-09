//
//  Location.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 8/1/2022.
//

import UIKit
import MapKit

// add possibility for other stuff jsut in case
class AnnotationInfo: ObservableObject{

    @Published var name: String = ""
    
    init() {
        print("initialising AnnotationInfo object")
    }
}
