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
    
    /* Convenience Methods for StudentLocationClient */
    
    public func readStudentLocations(limit: Int,
        completionHandler: StudentLocationArrayCompletionHandler) {
            
            Alamofire.request(Router.ReadStudentLocations(limit: limit))
                .responseJSON(options: .AllowFragments) { request, response, JSON, error in
                    if let error = error {
                        completionHandler(success: false, studentLocations: nil, error: error)
                    } else {
                        let json = JSON as! [String: AnyObject]
                        var studentLocations: [StudentLocation]?
                        studentLocations <-- json["results"]
                        
                        completionHandler(success: true, studentLocations: studentLocations, error: nil)
                    }
            }
    }
    
    public func createStudentLocation(studentLocation: StudentLocation,
        completionHandler: StudentLocationObjectCompletionHandler) {
            
            Alamofire.request(Router.CreateStudentLocation(studentLocation.toDictionary()))
                .responseJSON(options: .AllowFragments) { request, response, JSON, error in
                    
                    if let error = error {
                        completionHandler(success: false, studentLocation: nil, error: error)
                    } else {
                        let json = JSON as! [String: AnyObject]
                        var studentLocation = studentLocation
                        
                        studentLocation.objectId <-- json["objectId"]
                        studentLocation.createdAt <-- (json["createdAt"], StudentLocation.DateFormatString)
                        
                        completionHandler(success: true, studentLocation: studentLocation, error: nil)
                    }
            }
    }
    
    public func updateStudentLocation(studentLocation: StudentLocation,
        completionHandler: StudentLocationObjectCompletionHandler) {
            
            Alamofire.request(Router.UpdateStudentLocation(objectId: studentLocation.objectId!,
                studentLocation.toDictionary()))
                .responseJSON(options: .AllowFragments) { request, response, JSON, error in
             
                    if let error = error {
                        completionHandler(success: false, studentLocation: nil, error: error)
                    } else {
                        let json = JSON as! [String: AnyObject]
                        var studentLocation = studentLocation
                        
                        studentLocation.updatedAt <-- (json["updatedAt"], StudentLocation.DateFormatString)
                        
                        completionHandler(success: true, studentLocation: studentLocation, error: nil)
                    }
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
        case QueryStudentLocation(uniqueKey: String)
        
        var method: Alamofire.Method {
            switch self {
            case .CreateStudentLocation:
                return .POST
            case .ReadStudentLocations, .QueryStudentLocation:
                return .GET
            case .UpdateStudentLocation:
                return .PUT
            }
        }
        
        var path: String {
            switch self {
            case .CreateStudentLocation, .ReadStudentLocations, .QueryStudentLocation:
                return "StudentLocation"
            case .UpdateStudentLocation(let objectId, _):
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
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: ["limit": limit]).0
            case .UpdateStudentLocation(_, let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .QueryStudentLocation(let uniqueKey):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest,
                    parameters: [ "where" : "{\"uniqueKey\": \(uniqueKey)"]).0
            }
        }
        
    }
}

public typealias StudentLocationObjectCompletionHandler = (success: Bool, studentLocation: StudentLocation!, error: NSError!) -> Void
public typealias StudentLocationArrayCompletionHandler  = (success: Bool, studentLocations: [StudentLocation]!, error: NSError!) -> Void