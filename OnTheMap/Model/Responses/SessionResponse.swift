//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Jesse Morgan on 1/15/20.
//  Copyright © 2020 Jesse Morgan. All rights reserved.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct GetSessionResponse: Codable {
    let account: Account
    let session: Session
}

struct DeleteSessionResponse: Codable {
    let session: Session
}
