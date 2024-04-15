//
//  ViewController.swift
//  SamrtZiTask01
//
//  Created by Lavanya Ravichandran on 2024-04-10.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var bookNowButton: UIButton!

    let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var drivers: [Driver] = []

    var previousLocation: CLLocation?
    var userMarker: GMSMarker?
    
     var nearestDriver: Driver?

    let driverLocations = [
        CLLocationCoordinate2D(latitude: 9.7938, longitude: 80.2210), // Point Pedro
        CLLocationCoordinate2D(latitude: 9.826620, longitude: 80.227882), //Thambasiddy
        CLLocationCoordinate2D(latitude: 9.820043, longitude: 80.226653) // Thambasiddy
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Request location authorization
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        // Set up Google Maps
        let camera = GMSCameraPosition.camera(withLatitude: 13.068500, longitude: 80.234938, zoom: 10.0) // Default location
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        view.addSubview(bookNowButton)
        
        bookNowButton.frame = CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 50)
        
        // Creates markers for drivers' locations
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for (index, location) in driverLocations.enumerated() {
            let driverName = "Driver \(alphabet[alphabet.index(alphabet.startIndex, offsetBy: index)])"
            let driver = Driver(driverId: index + 1, driverName: driverName, coordinate: location)
            drivers.append(driver)

            let marker = GMSMarker(position: location)
            marker.title = driver.driverName
            marker.snippet = "Driver's Location"
            marker.icon = UIImage(named: "car_icon")
            marker.map = mapView
        }

        bookNowButton.addTarget(self, action: #selector(bookNowButtonTapped), for: .touchUpInside)
    }

    // MARK: - CLLocationManagerDelegate

    // Handle authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // Function to calculate the distance between two coordinates in meters
    func distanceBetween(_ location1: CLLocationCoordinate2D, _ location2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
        let location2 = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
        return location1.distance(from: location2)
    }

    // Function to update the distances between the user and each driver
    func updateDriverDistances(from userLocation: CLLocationCoordinate2D) {
        
        var isWithinThreshold = false
        
        for driver in drivers {
            let distance = distanceBetween(userLocation, driver.coordinate)
            print("Distance to \(driver.driverName): \(distance) meters")
            
            if distance < 1000 {
                isWithinThreshold = true
            }
        }
        
        bookNowButton.isEnabled = isWithinThreshold
        
    }

    // Handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        // Check if the new location is significantly different from the previous one
        if let previousLocation = previousLocation,
           newLocation.distance(from: previousLocation) < 10 {
            return
        }

        // Update the previous location
        previousLocation = newLocation

        let camera = GMSCameraPosition.camera(withLatitude: newLocation.coordinate.latitude,
                                              longitude: newLocation.coordinate.longitude,
                                              zoom: 12.0)
        mapView.animate(to: camera)
        
        // Update the user's marker
        if let marker = userMarker {
            marker.position = newLocation.coordinate
        } else {
            userMarker = GMSMarker(position: newLocation.coordinate)
            userMarker?.title = "Current Location"
            userMarker?.snippet = "User's Location"
            userMarker?.icon = GMSMarker.markerImage(with: .red) // Red marker for user
            userMarker?.map = mapView
        }
        
        // Update the distances between the user and each driver
        updateDriverDistances(from: newLocation.coordinate)
    }

    // MARK: - GMSMapViewDelegate

    // Handle marker tap events or other map interactions if needed

    // MARK: - Actions

    // Function called when the bookNow button is tapped
        @objc func bookNowButtonTapped() {
            
        // Find the nearest driver
            guard let userLocation = previousLocation?.coordinate else {
                print("User location not available")
                return
            }
            
            findNearestDriver(from: userLocation)
            
            // Print the nearest driver's name in the console
            if let nearestDriver = nearestDriver {
                print("Nearest driver: \(nearestDriver.driverName)")
            } else {
                print("No nearest driver found")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "MapToBooking", sender: self)
            }
        }
    
    // MARK: - Navigation

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            print("Preparing for segue...")
            if segue.identifier == "MapToBooking" {
                if let destinationVC = segue.destination as? BookingViewController {
                    // Pass the nearest driver object to the booking screen
                    destinationVC.nearestDriver = nearestDriver
                    
                    // Pass the user's current location to the booking screen
                    destinationVC.userCurrentLocation = previousLocation?.coordinate
                }
            }
        }
    
    func findNearestDriver(from userLocation: CLLocationCoordinate2D) {
           var minDistance: CLLocationDistance = Double.infinity
           var nearestDriver: Driver?
           
           for driver in drivers {
               let distance = distanceBetween(userLocation, driver.coordinate)
               if distance < minDistance {
                   minDistance = distance
                   nearestDriver = driver
               }
           }
           
           self.nearestDriver = nearestDriver
       }
    

}
