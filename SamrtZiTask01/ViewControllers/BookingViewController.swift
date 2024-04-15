//
//  BookingViewController.swift
//  SamrtZiTask01
//
//  Created by Lavanya Ravichandran on 2024-04-11.
//

import UIKit
import CountryPicker
import CoreLocation

struct Destination {
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class BookingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    // Outlets to interface elements in the storyboard
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var mobileNoField: UITextField!
    @IBOutlet weak var tripDateTextField: UITextField!
    @IBOutlet weak var tripTimeTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var driverNameTextField: UITextField!
    @IBOutlet weak var paymentTypeField: UITextField!
    @IBOutlet weak var bookingDateTextField: UITextField!
    @IBOutlet weak var bookingTimeTypeField: UITextField!
    
    @IBOutlet weak var TripDateTimeLabel: UILabel!
    @IBOutlet weak var DestinationLabel: UILabel!
    @IBOutlet weak var DriverLabel: UILabel!
    @IBOutlet weak var PaymentTypeLabel: UILabel!
    @IBOutlet weak var BookingDateTimeLabel: UILabel!
    
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    let paymentTypes = ["Credit/Debit Card", "Cash"]
    let destinations = ["Nelliady", "Jaffna", "Kodikamam"]
    
    let destinationsCoordinates: [Destination] = [
        Destination(name: "Nelliady", coordinate: CLLocationCoordinate2D(latitude: 9.7938, longitude: 80.2210)),
        Destination(name: "Jaffna", coordinate: CLLocationCoordinate2D(latitude: 9.8160, longitude: 80.2334)),
        Destination(name: "Kodikamam", coordinate: CLLocationCoordinate2D(latitude: 9.6615, longitude: 80.0255))
    ]

    
    // Property to store the nearest driver object passed from MapViewController
        var nearestDriver: Driver?
    
        var userCurrentLocation: CLLocationCoordinate2D?
    
        var bookingDetails: Booking?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryCodeTextField.isUserInteractionEnabled = true
        // Set up text field delegates
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        // Set the view title
        title = "User Booking"
        
        // Configure the title label
        titleLabel.text = "Booking"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        TripDateTimeLabel.text = "Trip Date & Time"
        DestinationLabel.text = "Destination"
        DriverLabel.text = "Driver Name"
        PaymentTypeLabel.text = "Payment Type"
        BookingDateTimeLabel.text = "Booking Date & Time"
        
        // Configure text fields
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.borderStyle = .roundedRect
        firstNameTextField.keyboardType = .default
        
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.borderStyle = .roundedRect
        lastNameTextField.keyboardType = .default
        
        countryCodeTextField.placeholder = "+94"
        countryCodeTextField.borderStyle = .roundedRect
        countryCodeTextField.keyboardType = .numberPad
        
        mobileNoField.placeholder = "Mobile Number"
        mobileNoField.borderStyle = .roundedRect
        mobileNoField.keyboardType = .phonePad
        
        tripDateTextField.placeholder = "Trip Date"
        tripDateTextField.borderStyle = .roundedRect
        tripDateTextField.inputView = UIDatePicker()
        
        tripTimeTextField.placeholder = "Trip Time"
        tripTimeTextField.borderStyle = .roundedRect
        tripTimeTextField.inputView = UIDatePicker()
        
        destinationTextField.placeholder = "Destination"
        destinationTextField.borderStyle = .roundedRect
        destinationTextField.inputView = UIPickerView()
        
        driverNameTextField.placeholder = "Driver Name"
        driverNameTextField.borderStyle = .roundedRect
        driverNameTextField.isEnabled = false // Prevent user input
        
        paymentTypeField.placeholder = "Payment Type"
        paymentTypeField.borderStyle = .roundedRect
        paymentTypeField.inputView = UIPickerView()
        
        bookingDateTextField.placeholder = "Booking Date"
        bookingDateTextField.borderStyle = .roundedRect
        bookingDateTextField.isEnabled = false // Prevent user input
        
        bookingTimeTypeField.placeholder = "Booking Time"
        bookingTimeTypeField.borderStyle = .roundedRect
        bookingTimeTypeField.isEnabled = false // Prevent user input
        
        bookButton.setTitle("Book Now", for: .normal)
        bookButton.backgroundColor = .systemBlue
        bookButton.setTitleColor(.white, for: .normal)
        bookButton.layer.cornerRadius = 8
        
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        
        // Add interface elements to the view
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(countryCodeTextField)
        view.addSubview(mobileNoField)
        view.addSubview(tripDateTextField)
        view.addSubview(tripTimeTextField)
        view.addSubview(destinationTextField)
        view.addSubview(driverNameTextField)
        view.addSubview(paymentTypeField)
        view.addSubview(bookingDateTextField)
        view.addSubview(bookingTimeTypeField)
        view.addSubview(bookButton)
        view.addSubview(backButton)
        
        // Set the frames for UI elements
        let textFieldWidth = view.frame.size.width - 40
        let textFieldHeight: CGFloat = 40
        let verticalSpacing: CGFloat = 10
        let buttonHeight: CGFloat = 50
        
        let labelHeight: CGFloat = 44
        titleLabel.frame = CGRect(x: 0, y: 40, width: view.frame.size.width, height: labelHeight)
        let horizontalSpacing: CGFloat = 5

        let smallVerticalSpacing: CGFloat = 0

        firstNameTextField.frame = CGRect(x: 20, y: titleLabel.frame.maxY + verticalSpacing, width: (textFieldWidth - horizontalSpacing) / 2, height: textFieldHeight)
        lastNameTextField.frame = CGRect(x: firstNameTextField.frame.maxX + horizontalSpacing, y: firstNameTextField.frame.origin.y, width: (textFieldWidth - horizontalSpacing) / 2, height: textFieldHeight)
        countryCodeTextField.frame = CGRect(x: 20, y: lastNameTextField.frame.maxY + verticalSpacing, width: 80, height: textFieldHeight)
        mobileNoField.frame = CGRect(x: countryCodeTextField.frame.maxX + 10, y: lastNameTextField.frame.maxY + verticalSpacing, width: textFieldWidth - 80 - 10, height: textFieldHeight)
        TripDateTimeLabel.frame = CGRect(x: 20, y: countryCodeTextField.frame.maxY + smallVerticalSpacing, width: textFieldWidth, height: labelHeight)
        tripDateTextField.frame = CGRect(x: 20, y: TripDateTimeLabel.frame.maxY, width: (textFieldWidth - horizontalSpacing) / 2, height: textFieldHeight)
        tripTimeTextField.frame = CGRect(x: tripDateTextField.frame.maxX + horizontalSpacing, y: TripDateTimeLabel.frame.maxY + smallVerticalSpacing, width: (textFieldWidth - horizontalSpacing) / 2, height: textFieldHeight)
        DestinationLabel.frame = CGRect(x: 20, y: tripDateTextField.frame.maxY + smallVerticalSpacing, width: textFieldWidth, height: labelHeight)
        destinationTextField.frame = CGRect(x: 20, y: DestinationLabel.frame.maxY, width: textFieldWidth, height: textFieldHeight)
        DriverLabel.frame = CGRect(x: 20, y: destinationTextField.frame.maxY + smallVerticalSpacing, width: textFieldWidth, height: labelHeight)
        driverNameTextField.frame = CGRect(x: 20, y: DriverLabel.frame.maxY, width: textFieldWidth, height: textFieldHeight)
        PaymentTypeLabel.frame = CGRect(x: 20, y: driverNameTextField.frame.maxY + smallVerticalSpacing, width: textFieldWidth, height: labelHeight)
        paymentTypeField.frame = CGRect(x: 20, y: PaymentTypeLabel.frame.maxY, width: textFieldWidth, height: textFieldHeight)
        BookingDateTimeLabel.frame = CGRect(x: 20, y: paymentTypeField.frame.maxY + smallVerticalSpacing, width: textFieldWidth, height: labelHeight)
        bookingDateTextField.frame = CGRect(x: 20, y: BookingDateTimeLabel.frame.maxY , width: (textFieldWidth - horizontalSpacing) / 2, height: textFieldHeight)
        bookingTimeTypeField.frame = CGRect(x: bookingDateTextField.frame.maxX + horizontalSpacing, y: BookingDateTimeLabel.frame.maxY + smallVerticalSpacing, width: (textFieldWidth - horizontalSpacing) / 2, height: textFieldHeight)
        bookButton.frame = CGRect(x: 20, y: bookingTimeTypeField.frame.maxY + verticalSpacing, width: textFieldWidth, height: buttonHeight)
        backButton.frame = CGRect(x: 0, y: 20, width: 80, height: 50)

        // Tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        createCountryPicker()

        // Configure picker views
        configurePickerViews()

        // Set initial values for text fields
        setInitialValues()

        // Disable past dates and times for date and time pickers
        configureDatePickers()
        configureTimePickers()

        bookButton.addTarget(self, action: #selector(bookButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
    

    }

    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == firstNameTextField || textField == lastNameTextField {
            // Allow only alphabetic characters and spaces
            let allowedCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: " "))
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else if textField == mobileNoField {
            // Allow only numeric characters and backspace
            let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacterSet.isSuperset(of: characterSet) || string.isEmpty
        }
        
        return true
    }
    
    func createCountryPicker() {
        let picker = CountryPicker()
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        countryCodeTextField.inputView = picker
        picker.selectRow(0, inComponent: 0, animated: true)
    }
    
    
    func configurePickerViews() {
            let paymentTypePicker = UIPickerView()
            paymentTypePicker.delegate = self
            paymentTypeField.inputView = paymentTypePicker
            
            let destinationPicker = UIPickerView()
            destinationPicker.delegate = self
            destinationTextField.inputView = destinationPicker
        }
        
        func setInitialValues() {
            
//            // If the nearest driver is available, print their name
            if let nearestDriver = nearestDriver {
                print("Nearest driver - Booking Screen : \(nearestDriver.driverName)")
                driverNameTextField.text = nearestDriver.driverName
            }
            
            // Set current date and time as default for booking date and time fields
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            bookingDateTextField.text = dateFormatter.string(from: currentDate)
            tripDateTextField.text = dateFormatter.string(from: currentDate)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .medium
            bookingTimeTypeField.text = timeFormatter.string(from: currentDate)
            tripTimeTextField.text = timeFormatter.string(from: currentDate)
            
            // Set default payment type
            paymentTypeField.text = paymentTypes.first
            
            // Set default destination
            destinationTextField.text = destinations.first
            

        }
        
        func configureDatePickers() {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.minimumDate = Date() // Disable past dates
            tripDateTextField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(tripDateChanged), for: .valueChanged)
        }
        
        func configureTimePickers() {
            let timePicker = UIDatePicker()
            timePicker.datePickerMode = .time
            timePicker.minimumDate = Date() // Disable past times
            tripTimeTextField.inputView = timePicker
            timePicker.addTarget(self, action: #selector(tripTimeChanged), for: .valueChanged)
        }
    
    // Function to update trip date text field when date picker value changes
        @objc func tripDateChanged(sender: UIDatePicker) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            tripDateTextField.text = dateFormatter.string(from: sender.date)
        }

        // Function to update trip time text field when time picker value changes
        @objc func tripTimeChanged(sender: UIDatePicker) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .medium
            tripTimeTextField.text = timeFormatter.string(from: sender.date)
        }
        
        // MARK: - UIPickerViewDataSource and UIPickerViewDelegate
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == paymentTypeField.inputView as? UIPickerView {
                return paymentTypes.count
            } else if pickerView == destinationTextField.inputView as? UIPickerView {
                return destinations.count
            }
            return 0
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == paymentTypeField.inputView as? UIPickerView {
                return paymentTypes[row]
            } else if pickerView == destinationTextField.inputView as? UIPickerView {
                return destinations[row]
            }
            return nil
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView == paymentTypeField.inputView as? UIPickerView {
                paymentTypeField.text = paymentTypes[row]
            } else if pickerView == destinationTextField.inputView as? UIPickerView {
                destinationTextField.text = destinations[row]
            }
        }


    
    // MARK: - Actions
    
    // Function called when the Book button is tapped
    @objc func bookButtonTapped() {
        // Perform validation
        if validateInputs() {
            // All inputs are valid, show confirmation alert
            showConfirmationAlert()
        } else {
            // Validation failed, show an error message to the user or handle it accordingly
            print("Validation failed. Please check your inputs.")
        }
    }

    // Function to show confirmation alert
    func showConfirmationAlert() {
        // Create the alert
        let alert = UIAlertController(title: "Confirm Booking", message: "Are you sure you want to proceed with the booking?", preferredStyle: .alert)
        
        // Add actions to the alert
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            // User confirmed the booking, proceed with navigation
            self.performSegue(withIdentifier: "BookingDetailsSegue", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }

    
    
    // Function called when the Back button is tapped
        @objc func backButtonTapped() {
            // to perform the segue to LoginViewController
            performSegue(withIdentifier: "BackToMap", sender: self)
        }
    
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookingDetailsSegue" {
            if let destinationVC = segue.destination as? BookingDetailsViewController {
                let booking = createBooking()
                destinationVC.bookingDetails = booking
            }
        }
    }
    
    let defaultUserLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

    
    private func createBooking() -> Booking {
        
        guard let selectedDestinationName = destinationTextField.text,
                      let selectedDestination = destinationsCoordinates.first(where: { $0.name == selectedDestinationName }) else {
                    fatalError("Selected destination not found")
                }

        let distanceToDestination = distanceBetween(userCurrentLocation ?? defaultUserLocation, selectedDestination.coordinate)
                let fee = (distanceToDestination/1000) * 100 // Assuming 100 LKR per meter
                print("distanceToDestination: ", distanceToDestination)
                print("fee: " , fee)
        
        return Booking(firstName: firstNameTextField.text ?? "",
                       lastName: lastNameTextField.text ?? "",
                       countryCode: countryCodeTextField.text ?? "",
                       mobileNumber: mobileNoField.text ?? "",
                       tripDate: tripDateTextField.text ?? "",
                       tripTime: tripTimeTextField.text ?? "",
                       destination: destinationTextField.text ?? "",
                       driverName: driverNameTextField.text ?? "",
                       paymentType: paymentTypeField.text ?? "",
                       bookingDate: bookingDateTextField.text ?? "",
                       bookingTime: bookingTimeTypeField.text ?? "",
                       userLocation: userCurrentLocation ?? defaultUserLocation ,
                       distanceToDestination: distanceToDestination,
                       fee: fee
        )
    }
    
    // Function to calculate the distance between two coordinates in meters
    func distanceBetween(_ location1: CLLocationCoordinate2D, _ location2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
        let location2 = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
        return location1.distance(from: location2)
    }
    
    // Function to perform validation on all input fields
    func validateInputs() -> Bool {
        // Validate first name and last name
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            showAlert(message: "First name is required.")
            return false
        }
        
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            showAlert(message: "Last name is required.")
            return false
        }
        
        // Validate mobile number
        guard let mobileNumber = mobileNoField.text, !mobileNumber.isEmpty else {
            showAlert(message: "Mobile number is required.")
            return false
        }
        
        // Check minimum and maximum count of numbers for mobile number
        let mobileNumberCount = mobileNumber.trimmingCharacters(in: .whitespacesAndNewlines).count
        if mobileNumberCount < 9 {
            showAlert(message: "Mobile number should be at least 9 digits.")
            return false
        }
        
        if mobileNumberCount > 12 {
            showAlert(message: "Mobile number should not exceed 12 digits.")
            return false
        }
        
        return true
    }
    
    // Function to display an alert message
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension BookingViewController: CountryPickerDelegate{
    //MARK: - Country Code Picker Delegate
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        countryCodeTextField.text = phoneCode
    }
    
}
