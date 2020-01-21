//
//  SessionRequest.swift
//  OnTheMap
//
//  Created by Jesse Morgan on 1/15/20.
//  Copyright © 2020 Jesse Morgan. All rights reserved.
//

import Foundation

struct UdacityAccount: Codable {
    let username: String
    let password: String
}

struct GetSessionRequest: Codable {
    let udacity: UdacityAccount
}
