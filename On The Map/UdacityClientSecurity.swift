//
//  UdacityClientSecurity.swift
//  On The Map
//
//  Created by James Gilchrist on 4/9/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func loginWithUsernameAndPassword(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        /* 1. Get the users id by creating a new session with username and password */
        getUserID(username, password: password) { success, userID, errorString in
            
            if success {
                
                /* 2. Fetch the users public data for First & Last Name */
                self.getUsersPublicData(userID!) { succes, udacityUser, errorString in
                    
                    if success {
                        
                        /* 3. Store the appropriate user data for later use in Udacity Parse Client */
                        self.user = udacityUser
                        
                    }
                    completionHandler(success: success, errorString: errorString)
                }
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    func getUserID(username: String, password: String, completionHandler: (success: Bool, userID: Int?, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.udacityDataTaskWithRequest(request) { data, response, error in
            
            if let error = error? {
                
                completionHandler(success: false, userID: nil, errorString: "Login Failed (Invalid Credentials")
                
            } else {
                
                var parseError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &parseError) as NSDictionary
                
                if let status = parsedResult.valueForKey("status") as? Int {
                    
                    completionHandler(success: false, userID: nil, errorString: "Login Failed (Server Response)")
                    
                } else {
                    
                    let account = parsedResult.valueForKey("account") as [String: AnyObject]
                    let session = parsedResult.valueForKey("session") as [String: AnyObject]
                    
                    let key = account["key"] as String
                    if let userID = key.toInt() {
                        
                        completionHandler(success: true, userID: userID, errorString: nil)
                        
                    } else {
                        
                        completionHandler(success: false, userID: nil, errorString: "Login Failed (Bad User ID)")
                        
                    }
                }
                
            }
        }
        task.resume()
    }
    
    func getUsersPublicData(userID: Int, completionHandler: (success: Bool, udacityUser: UdacityUser?, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userID)")!)
        
        let task = session.udacityDataTaskWithRequest(request) { data, response, error in
            
            if let error = error? {
                
                completionHandler(success: false, udacityUser: nil, errorString: "Login Failed (Server Error)")
                
            } else {
                var parseError: NSError? = nil
                var parseResult = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &parseError) as NSDictionary
                
                let user = parseResult["user"] as [String: AnyObject]
                let firstName = user["first_name"] as String
                let lastName = user["last_name"] as String
                
                let udacityUser = UdacityUser(userID: userID, firstName: firstName, lastName: lastName)
                
                
                completionHandler(success: true, udacityUser: udacityUser, errorString: nil)
                
            }
        }
        task.resume()
    }

}