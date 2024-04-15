//
//  Booking.swift
//  SamrtZiTask01
//
//  Created by Lavanya Ravichandran on 2024-04-14.
//

import Foundation
import CoreLocation

class Booking {
    var firstName: String
    var lastName: String
    var countryCode: String
    var mobileNumber: String
    var tripDate: String
    var tripTime: String
    var destination: String
    var driverName: String
    var paymentType: String
    var bookingDate: String
    var bookingTime: String
    var userLocation: CLLocationCoordinate2D
    var distanceToDestination: CLLocationDistance = 0 // Distance in meters
    var fee: Double = 0 // Fee in LKR

    init(firstName: String, lastName: String, countryCode: String, mobileNumber: String, tripDate: String, tripTime: String, destination: String, driverName: String, paymentType: String, bookingDate: String, bookingTime: String, userLocation: CLLocationCoordinate2D, distanceToDestination: CLLocationDistance, fee: Double) {
        self.firstName = firstName
        self.lastName = lastName
        self.countryCode = countryCode
        self.mobileNumber = mobileNumber
        self.tripDate = tripDate
        self.tripTime = tripTime
        self.destination = destination
        self.driverName = driverName
        self.paymentType = paymentType
        self.bookingDate = bookingDate
        self.bookingTime = bookingTime
        self.userLocation = userLocation
        self.distanceToDestination = distanceToDestination
        self.fee = fee
    }
}

