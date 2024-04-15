//
//  Driver.swift
//  SamrtZiTask01
//
//  Created by Lavanya Ravichandran on 2024-04-14.
//

import Foundation
import CoreLocation

class Driver {
    let driverId: Int
    let driverName: String
    let coordinate: CLLocationCoordinate2D

    init(driverId: Int, driverName: String, coordinate: CLLocationCoordinate2D) {
        self.driverId = driverId
        self.driverName = driverName
        self.coordinate = coordinate
    }
}
