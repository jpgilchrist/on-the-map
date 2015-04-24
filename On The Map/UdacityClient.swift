//
//  UdacityClient.swift
//  On The Map
//
//  Created by James Gilchrist on 4/8/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation
import Alamofire

class UdacityClient {
    
    var session: NSURLSession!

    var user : UdacityUser?
    
    init() {
        self.session = NSURLSession.sharedSession()
    }
    
    func logout(completionHandler: () -> Void) {
        self.session = nil
        self.user = nil
        completionHandler()
    }
    
    func loginWithUsernameAndPassword(username: String, password: String, completionHandler: (success: Bool, message: String?) -> Void) {
        loginAndExtractPublicData(Alamofire.request(Router.Login(username: username, password: password)), completionHandler: completionHandler)
    }

    func loginWithFacebook(accessToken: String, completionHandler: (success: Bool, message: String?) -> Void) {
        loginAndExtractPublicData(Alamofire.request(Router.FacebookLogin(accessTokenString: accessToken)), completionHandler: completionHandler)
    }
    
    func loginAndExtractPublicData(request: Request, completionHandler: (success: Bool, message: String?) -> Void) {
        request.validate() //HTTP Response Code 200 - 299, otherwise there's an error
            .responseUdacityJSON() { request, response, JSON, error in
                
                if let error = error {
                    self.handleErrors(response, json: JSON, completionHandler: completionHandler)
                } else {
                    
                    let account = JSON!["account"] as! [String:AnyObject]
                    let uniqueKey = account["key"] as! String
                    
                    Alamofire.request(Router.ReadPublicData(userId: uniqueKey))
                        .validate() //HTTP Response Code 200 - 299
                        .responseUdacityJSON() { request, response, JSON, error in
                            
                            if let error = error {
                                self.handleErrors(response, json: JSON, completionHandler: completionHandler)
                            } else {
                                let user = JSON!["user"] as! [String: AnyObject]
                                let firstName = user["first_name"] as! String
                                let lastName  = user["last_name"]  as! String
                                
                                let udacityUser = UdacityUser(userID: uniqueKey, firstName: firstName, lastName: lastName)
                                self.user = udacityUser
                                
                                completionHandler(success: true, message: nil)
                            }
                    }
                }
        }

    }
    
    func handleErrors(response: NSHTTPURLResponse?, json: [String:AnyObject]?, completionHandler: (success: Bool, message: String?) -> Void) {
        if let response = response {
            switch response.statusCode {
            case 400:
                var message = json!["error"] as! String
                message = message.stringByReplacingOccurrencesOfString("trails.Error 400: ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                completionHandler(success: false, message: message)
            case 403:
                var message = json!["error"] as! String
                completionHandler(success: false, message: message)
            default:
                completionHandler(success: false, message: "Unknown Server Error.")
            }
        } else {
            completionHandler(success: false, message: "Network Error. Please check your connection.")
        }
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static let sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    private enum Router: URLRequestConvertible {
        
        static let baseURLString = "https://www.udacity.com/api/"
        
        case Login(username: String, password: String)
        case FacebookLogin(accessTokenString: String)
        case ReadPublicData(userId: String)
        
        var path: String {
            switch self {
            case .Login, .FacebookLogin:
                return "session"
            case .ReadPublicData(let userId):
                return "users/\(userId)"
            }
        }
        
        var method: Alamofire.Method {
            switch self {
            case .Login, .FacebookLogin:
                return .POST
            case .ReadPublicData:
                return .GET
            }
        }
        
        var URLRequest: NSURLRequest {
            let url = NSURL(string: Router.baseURLString)!

            let mutableRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
            mutableRequest.HTTPMethod = method.rawValue
            mutableRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            switch self {
            case .Login(let username, let password):
                mutableRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                return Alamofire.ParameterEncoding.JSON.encode(mutableRequest, parameters:
                    [ "udacity": [ "username": "\(username)", "password": "\(password)" ]]).0
            case .FacebookLogin(let token):
                mutableRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                return Alamofire.ParameterEncoding.JSON.encode(mutableRequest, parameters:
                    [ "facebook_mobile": [ "access_token": "\(token)" ] ]).0
            case .ReadPublicData:
                return mutableRequest
            }
        }
    }
}

extension Request {
    class func UdacityJSONSerializer() -> Serializer {
        return { (request, response, data) in
            
            if data == nil || data?.length == 0 {
                return (nil, nil)
            }
            
            let shiftedData = data!.subdataWithRange(NSMakeRange(5, (data!.length - 5)))
            
            var JSONSerializationError: NSError?
            let JSON = NSJSONSerialization.JSONObjectWithData(shiftedData, options: .AllowFragments, error: &JSONSerializationError) as! [String:AnyObject]
            
            if let error = JSONSerializationError {
                return (nil, NSError(domain: "com.jpgilchrist.OnTheMap", code: 1, userInfo: [ "message" : "Server Error. The server returned malformed data."]))
            }
            
            return (JSON, nil)
        }
    }
    
    func responseUdacityJSON(completionHandler: (NSURLRequest, NSHTTPURLResponse?, [String: AnyObject]?, NSError?) -> Void) -> Self {
        return response(serializer: Request.UdacityJSONSerializer(), completionHandler: { (request, response, JSON, error) in
            completionHandler(request, response, JSON as? [String:AnyObject], error)
        })
    }
}