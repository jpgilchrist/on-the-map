//
//  UdacityClient.swift
//  On The Map
//
//  Created by James Gilchrist on 4/8/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    var session: NSURLSession
    
    override init() {
        self.session = NSURLSession.sharedSession()
        super.init()
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static let sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    func loginWithUsernameAndPassword(username: String, password: String, completionHandler: () -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler()
            } else {
                let subsetData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                
                var parseError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(subsetData, options: .AllowFragments, error: &parseError) as NSDictionary
                
                if let status = parsedResult.valueForKey("status") as? Int {
                    let error = parsedResult.valueForKey("error") as String
                    println("Login Error (\(status)): \(error)")
                    completionHandler()
                } else {
                    let account = parsedResult.valueForKey("account") as [String: AnyObject]
                    let session = parsedResult.valueForKey("session") as [String: AnyObject]
                    println("Login Success \(account) \(session )")
                    
                    if let userID = account["key"] as? Int {
                        
                    }
                }
                
            }
        }
        task.resume()

    }
}