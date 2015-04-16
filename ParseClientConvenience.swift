//
//  ParseClientConvenience.swift
//  On The Map
//
//  Created by James Gilchrist on 4/15/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation

extension ParseClient {
    /*
        Method: https://api.parse.com/1/classes/StudentLocation
        Method Type: GET
        Optional Parameters:
            limit - (Number) specifies the maximum number of StudentLocation objects to return in the JSON response
        ex: https://api.parse.com/1/classes/StudentLocation?limit=100
    */
    func getStudentLocationsWithLimit(limit: Int, completionHandler: (success: Bool, result: AnyObject!, error: NSError!) -> Void) {
        
        /* 1. Build URL: https://api.parse.com/1/classes/StudentLocation?limit=100 */
        let methodURL = NSURL(string: "\(ParseClient.Methods.StudentLocations)?limit=\(limit)")!
        
        /* 2. Build Mutable URL Request with some predefined headers */
        var mutableRequest = baseRequestWithDefaultHeaders(methodURL)
        
        /* 3. Create data task with request */
        let task = session.dataTaskWithRequest(mutableRequest) { data, response, error in
            
            /* 4a. There was an error with the request */
            if let error = error {
                completionHandler(success: false, result: nil, error: error)
            } else {
                
                /* 4b. Parse the data returned by the request as JSON Dictionary [String: AnyObject] */
                var jsonReadError: NSError? = nil
                var jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &jsonReadError) as! [String: AnyObject]
                
                /* 5a. There was an error reading the data */
                if let error = jsonReadError {
                    completionHandler(success: false, result: nil, error: error)
                } else {
                    /* 5b. TODO: build [StudentLocation] to return to view controllers */
                    completionHandler(success: true, result: jsonObject, error: nil)
                }
                
            }
            
        }
        
        /* 6. Start the task */
        task.resume()
    }
    
    /*
        Method: https://api.parse.com/1/classes/StudentLocation
        Method Type: POST
    */
    
}