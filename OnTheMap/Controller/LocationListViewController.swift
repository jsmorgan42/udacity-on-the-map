//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Jesse Morgan on 1/15/20.
//  Copyright © 2020 Jesse Morgan. All rights reserved.
//

import UIKit

class LocationListViewController: UITableViewController {

    @IBOutlet var listBarButton: UITabBarItem!
    
    var locations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadLocationData()
    }
    
    private func reloadLocationData() {
        UdacityClient.getMostRecentStudentLocations { (locations, error) in
            StudentLocationModel.locations = locations
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func refreshTable(_ sender: Any) {
        self.reloadLocationData()
    }
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout { (success, error) in
            if success {
                print("User successfully logged out.")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationModel.locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell")!
        
        let location = StudentLocationModel.locations[indexPath.row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel?.text = location.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let toOpen = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text {
            UIApplication.shared.open(URL(string: toOpen)!, options: [:]) { (success) in
                if !success {
                    let alert = UIAlertController(title: "Error opening URL", message: "The URL link associated with this pin is not valid.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
}
