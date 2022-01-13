//
//  Marker.swift
//  MoshMate_v1
//
//  Created by Lucas Zeng on 13/1/2022.
//

import Foundation

struct Marker: Hashable {
    let degrees: Double
    let label: String

    init(degrees: Double, label: String = "") {
        self.degrees = degrees
        self.label = label
    }
}
