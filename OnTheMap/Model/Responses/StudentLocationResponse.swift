//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Jesse Morgan on 1/15/20.
//  Copyright © 2020 Jesse Morgan. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}

struct StudentLocationPOSTResponse: Codable {
    let createdAt: String
    let objectId: String
}

struct StudentLocationResponse: Codable {
    let locations: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case locations = "results"
    }
}
