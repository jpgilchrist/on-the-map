//
//  StudentLocationClient.swift
//  On The Map
//
//  Created by James Gilchrist on 4/15/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation
import Alamofire
import JSONHelper

public class StudentLocationClient {
    
    var studentLocations: [StudentLocation]?
    var usersLocations: [StudentLocation]?
    
    /* Convenience Methods for StudentLocationClient */
    
    public func refreshStudentLocations(limit: Int,
        completionHandler: (success: Bool, message: String!) -> Void) {
            
            Alamofire.request(Router.ReadStudentLocations(limit: limit))
                .validate()
                .responseJSON(options: .AllowFragments) { request, response, JSON, error in
                    if let error = error {
                        self.handleErrors(response, json: JSON, completionHandler: completionHandler)
                    } else {
                        let json = JSON as! [String: AnyObject]
                    
                        self.studentLocations <-- json["results"]
                        
                        completionHandler(success: true, message: nil)
                    }
            }
    }
    
    public func createStudentLocation(studentLocation: StudentLocation,
        completionHandler: (success: Bool, message: String!) -> Void) {
            
            Alamofire.request(Router.CreateStudentLocation(studentLocation.toDictionary()))
                .validate()
                .responseJSON(options: .AllowFragments) { request, response, JSON, error in
                    
                    if let error = error {
                        self.handleErrors(response, json: JSON, completionHandler: completionHandler)
                    } else {
                        let json = JSON as! [String: AnyObject]
                        var studentLocation = studentLocation
                        
                        studentLocation.objectId <-- json["objectId"]
                        studentLocation.createdAt <-- (json["createdAt"], StudentLocation.DateFormatString)
                        
                        self.studentLocations?.insert(studentLocation, atIndex: 0)
                        
                        completionHandler(success: true, message: nil)
                    }
            }
    }
    
    public func findStudentLocationsByUniqueKey(uniqueKey: String,
        completionHandler: (success: Bool, message: String!) -> Void) {
            
            Alamofire.request(Router.FindByUniqueKey(uniqueKey: uniqueKey))
                .validate()
                .responseJSON(options: .AllowFragments) { request, response, JSON, error in
                
                    if let error = error {
                        self.handleErrors(response, json: JSON, completionHandler: completionHandler)
                    } else {
                        let json = JSON as! [String: AnyObject]
                        var studentLocations: [StudentLocation]?
                        studentLocations <-- json["results"]
                        
                        self.usersLocations = studentLocations
                        
                        completionHandler(success: true, message: nil)
                        
                    }
                    
            }
    }
    
    public func destroyStudentLocationByObjectId(objectId: String,
        completionHandler: (success: Bool, message: String!) -> Void) {
            
            Alamofire.request(Router.DestroyStudentLocation(objectId: objectId))
                .validate()
                .responseJSON(options: .AllowFragments) { request, response, JSON, error in
                    
                    if let error = error {
                        self.handleErrors(response, json: JSON, completionHandler: completionHandler)
                    } else {
                        completionHandler(success: true, message: nil)
                    }
            }
    }
    
    func handleErrors(response: NSHTTPURLResponse?, json: AnyObject?, completionHandler: (success: Bool, message: String!) -> Void) {
        if let response = response {
            completionHandler(success: false, message: "Server Error. \(response.statusCode)")
        } else {
            completionHandler(success: false, message: "Network Error. Please check your connection.")
        }
    }
    
    public class func sharedInstance() -> StudentLocationClient {
        struct Singleton {
            static let sharedInstance = StudentLocationClient()
        }
        return Singleton.sharedInstance
    }
    
    /* Router For Parse Client Student Locations */
    private enum Router: URLRequestConvertible {
        static let baseURLString = "https://api.parse.com/1/classes"
        
        case CreateStudentLocation([String: AnyObject])
        case ReadStudentLocations(limit: Int)
        case UpdateStudentLocation(objectId: String, [String: AnyObject])
        case DestroyStudentLocation(objectId: String)
        case FindByUniqueKey(uniqueKey: String)
        case FindByObjectId(objectId: String)
        
        var method: Alamofire.Method {
            switch self {
            case .CreateStudentLocation:
                return .POST
            case .ReadStudentLocations, .FindByUniqueKey, .FindByObjectId:
                return .GET
            case .UpdateStudentLocation:
                return .PUT
            case .DestroyStudentLocation:
                return .DELETE
            }
        }
        
        var path: String {
            switch self {
            case .CreateStudentLocation, .ReadStudentLocations, .FindByUniqueKey:
                return "StudentLocation"
            case .FindByObjectId(let objectId):
                return "StudentLocation/\(objectId)"
            case .UpdateStudentLocation(let objectId, _):
                return "StudentLocation/\(objectId)"
            case .DestroyStudentLocation(let objectId):
                return "StudentLocation/\(objectId)"
            }
        }
        
        var URLRequest: NSURLRequest {
            let URL = NSURL(string: Router.baseURLString)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            
            mutableURLRequest.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
                forHTTPHeaderField: "X-Parse-Application-Id")
            mutableURLRequest.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
                forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            switch self {
            case .CreateStudentLocation(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .ReadStudentLocations(let limit):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: ["limit": limit, "order":"-createdAt"]).0
            case .UpdateStudentLocation(_, let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .FindByUniqueKey(let uniqueKey):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest,
                    parameters: [ "where" : "{\"uniqueKey\": \"\(uniqueKey)\"}"]).0
            case .DestroyStudentLocation, .FindByObjectId:
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: [:]).0
            }
        }
        
    }
}