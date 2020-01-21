//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Jesse Morgan on 1/15/20.
//  Copyright © 2020 Jesse Morgan. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var urlTextField: UITextField!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var location = CLLocation()
    
    override func viewDidLoad() {
        spinner.isHidden = true
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        let geoCoder = CLGeocoder()
        startSpinner()
        geoCoder.geocodeAddressString(locationTextField.text ?? "") { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                self.stopSpinner()
                let alert = UIAlertController(title: "Location Error", message: "That is not a valid location. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            self.stopSpinner()
            self.location = location
            self.performSegue(withIdentifier: "FindLocationSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FindLocationSegue") {
            if let vc = segue.destination as? ConfirmLocationViewController {
                vc.location = location
                vc.locationName = locationTextField.text ?? ""
                vc.mediaURL = urlTextField.text ?? ""
            }
        }
    }
    
    func startSpinner() {
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
}
