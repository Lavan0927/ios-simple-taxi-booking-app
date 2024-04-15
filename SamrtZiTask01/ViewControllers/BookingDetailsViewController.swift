//
//  BookingDetailsViewController.swift
//  SamrtZiTask01
//
//  Created by Lavanya Ravichandran on 2024-04-14.
//

import Foundation
import UIKit

class BookingDetailsViewController: UIViewController {
    
    // Outlets to interface elements in the storyboard
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var tripDataLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var bookingDateAndTimeLabel: UILabel!
    @IBOutlet weak var distanceToDestinationLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    var bookingDetails: Booking?
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           // Set the view title
        title = "Booking Details"

           configureTitleLabel()
           configurebackButton()
           configureLabels()
           updateUI()
        
           backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
       }
       
       private func configureTitleLabel() {
           titleLabel.text = "Booking Details"
           titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
           titleLabel.textAlignment = .center
           titleLabel.frame = CGRect(x: 0, y: 40, width: view.frame.size.width, height: 44)
           view.addSubview(titleLabel)
       }
    
    private func configurebackButton() {
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.frame = CGRect(x: 0, y: 20, width: 80, height: 50)
        view.addSubview(backButton)
    }
       
    private func configureLabels() {
        let labelWidth = view.frame.size.width - 40
        let labelHeight: CGFloat = 24
        let labelSpacing: CGFloat = 10
        
        var nextLabelY = titleLabel.frame.maxY + 20
        
        for label in [fullNameLabel, mobileNumberLabel, tripDataLabel, destinationLabel, driverNameLabel, paymentTypeLabel, bookingDateAndTimeLabel, distanceToDestinationLabel, feeLabel] {
            guard let unwrappedLabel = label else { continue }
            unwrappedLabel.font = UIFont.systemFont(ofSize: 16)
            unwrappedLabel.numberOfLines = 0
            unwrappedLabel.frame = CGRect(x: 20, y: nextLabelY, width: labelWidth, height: labelHeight)
            view.addSubview(unwrappedLabel)
            nextLabelY += labelHeight + labelSpacing
        }
    }

       
       private func updateUI() {
           guard let booking = bookingDetails else { return }
           
           fullNameLabel.text = "Full Name: \(booking.firstName) \(booking.lastName)"
           mobileNumberLabel.text = "Mobile No: \(booking.countryCode) \(booking.mobileNumber)"
           tripDataLabel.text = "Trip Date & Time: \(booking.tripDate) \(booking.tripTime)"
           destinationLabel.text = "Destination: \(booking.destination)"
           driverNameLabel.text = "Driver Name: \(booking.driverName)"
           paymentTypeLabel.text = "Payment Type: \(booking.paymentType)"
           bookingDateAndTimeLabel.text = "Booking Date & Time: \(booking.bookingDate) \(booking.bookingTime)"
           
           // Round distance to the second decimal place
            let distance = String(format: "%.2f", booking.distanceToDestination)
            distanceToDestinationLabel.text = "Distance to Destination: \(distance) meters"
            
            // Round fee to the second decimal place
            let fee = String(format: "%.2f", booking.fee)
            feeLabel.text = "Fee: \(fee) LKR"
       }
    
    // Function called when the Back button is tapped
        @objc func backButtonTapped() {
            // to perform the segue to MapViewController
            performSegue(withIdentifier: "BookingDetailsToMap", sender: self)
        }
   }
