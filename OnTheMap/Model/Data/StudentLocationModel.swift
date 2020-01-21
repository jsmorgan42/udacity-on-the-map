//
//  StudentLocationModel.swift
//  OnTheMap
//
//  Created by Jesse Morgan on 1/15/20.
//  Copyright © 2020 Jesse Morgan. All rights reserved.
//

import Foundation

class StudentLocationModel {
    
    static var locations = [StudentLocation]()
    static var currentLocation = StudentLocation(createdAt: "", firstName: "", lastName: "", latitude: 0.0, longitude: 0.0, mapString: "", mediaURL: "", objectId: "", uniqueKey: "", updatedAt: "")
    static var hasLocation = false
    
}
