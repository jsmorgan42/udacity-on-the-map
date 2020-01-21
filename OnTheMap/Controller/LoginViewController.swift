//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jesse Morgan on 1/15/20.
//  Copyright © 2020 Jesse Morgan. All rights reserved.
//g

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMapData()
        loginButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailField.text = ""
        passwordField.text = ""
    }
    
    func loadMapData() {
        UdacityClient.getMostRecentStudentLocations { (locations, error) in
            StudentLocationModel.locations = locations
        }
    }
    
    @IBAction func login(_ sender: Any) {
        UdacityClient.login(username: emailField.text ?? "", password: passwordField.text ?? "") { (success, error) in
            if success {
                print("User successfully logged in.")
                UdacityClient.getSpecificStudentLocation(uniqueKey: UdacityClient.Auth.uniqueKey) { (studentLocation, error) in
                    if (error != nil) {
                        StudentLocationModel.hasLocation = false
                    } else {
                        StudentLocationModel.hasLocation = true
                        StudentLocationModel.currentLocation = studentLocation
                    }
                    
                }
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            } else {
                print("User failed to log in.")
                
                // Present alert error message
                let alert = UIAlertController(title: "Login Error", message: "The credentials you entered are not correct. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }

    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!)
    }
    
}

