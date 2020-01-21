//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Jesse Morgan on 1/15/20.
//  Copyright © 2020 Jesse Morgan. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var location = CLLocation()
    var locationName = ""
    var mediaURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMapRegion()
    }
    
    func prepareMapRegion() {
        mapView.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        
        self.mapView.addAnnotation(annotation)
        
        let regionRadius: CLLocationDistance = 400
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func finish(_ sender: Any) {
//        UdacityClient.getSpecificStudentLocation(uniqueKey: UdacityClient.Auth.uniqueKey) { (studentLocation, error) in
//            UdacityClient.updateStudentLocation(location: studentLocation) { (success, error) in

//            }
//        }
        
        let studentLocation = StudentLocationPOSTRequest(uniqueKey: UdacityClient.Auth.uniqueKey, firstName: "Tim", lastName: "Allen", mapString: locationName,
                                                  mediaURL: mediaURL, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        UdacityClient.addStudentLocation(location: studentLocation) { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Server Error", message: "Oops something went wrong. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                print(error.debugDescription)
            }
        }
        
    }
    
}
