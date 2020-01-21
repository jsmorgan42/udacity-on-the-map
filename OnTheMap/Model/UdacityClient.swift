//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Jesse Morgan on 1/15/20.
//  Copyright © 2020 Jesse Morgan. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
        static var uniqueKey = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case getSession
        case deleteSession
        case getAllStudentLocations
        case getMostRecent100StudentLocations
        case createStudentLocation
        case updateStudentLocation(String)
        case getSpecificStudentLocation(String)
        case getUserData(String)
        
        var stringValue: String {
            switch self {
            case .getSession:
                return Endpoints.base + "session"
            case .deleteSession:
                return Endpoints.base + "session"
            case .getAllStudentLocations:
                return Endpoints.base + "StudentLocation"
            case .getMostRecent100StudentLocations:
                return Endpoints.base + "StudentLocation" + "?order=-updatedAt" + "?limit=200"
            case .createStudentLocation:
                return Endpoints.base + "StudentLocation"
            case .updateStudentLocation(let objectID):
                return Endpoints.base + "StudentLocation" + objectID
            case .getSpecificStudentLocation(let uniqueKey):
                return Endpoints.base + "StudentLocation" + "?uniqueKey=\(uniqueKey)"
            case .getUserData(let userId):
                return Endpoints.base + "users/" + userId
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(removeInitialCharacters: Bool = true, url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                if error != nil { // Handle error…
                    return
                }
                // Get rid of first 5 characters in JSON specified by the Udacity API docs
                var newData = data
                if removeInitialCharacters {
                    let range = 5..<data.count
                    newData = data.subdata(in: range)
                }
                
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                if error != nil { // Handle error…
                    return
                }
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    //let errorResponse = try decoder.decode(TMDBResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = GetSessionRequest(udacity: UdacityAccount(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.getSession.url, responseType: GetSessionResponse.self, body: body) { response, error in
            if let response = response {
                Auth.uniqueKey = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.deleteSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
        task.resume()
    }
    
    class func getMostRecentStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        _ = taskForGETRequest(url: Endpoints.getMostRecent100StudentLocations.url, responseType: StudentLocationResponse.self) { (response, error) in
            if let response = response {
                completion(response.locations, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getAllStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        _ = taskForGETRequest(url: Endpoints.getAllStudentLocations.url, responseType: StudentLocationResponse.self) { (response, error) in
            if let response = response {
                completion(response.locations, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getSpecificStudentLocation(uniqueKey: String, completion: @escaping (StudentLocation, Error?) -> Void) {
        _ = taskForGETRequest(url: Endpoints.getSpecificStudentLocation(uniqueKey).url, responseType: StudentLocation.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(StudentLocationModel.currentLocation, error)
                return
            }
        }
    }
    
    class func addStudentLocation(location: StudentLocationPOSTRequest, completion: @escaping (Bool, Error?) -> Void) {
        _ = taskForPOSTRequest(removeInitialCharacters: false, url: Endpoints.createStudentLocation.url, responseType: StudentLocationPOSTResponse.self, body: location) { (response, error) in
            if response != nil {
                completion(true, nil)
            } else {
                completion(false, error)
                return
            }
        }
    }
    
    class func updateStudentLocation(location: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
        let url = Endpoints.updateStudentLocation(location.objectId).url
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = location
        request.httpBody = try! JSONEncoder().encode(body)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
        task.resume()
    }
    
}
