//
//  StudentLocationRequest.swift
//  OnTheMap
//
//  Created by Jesse Morgan on 1/16/20.
//  Copyright © 2020 Jesse Morgan. All rights reserved.
//

import Foundation

struct StudentLocationPOSTRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
