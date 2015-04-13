//
//  UdacityClientLocations.swift
//  On The Map
//
//  Created by James Gilchrist on 4/9/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func getStudentLocations(completionHandler: (success: Bool, studentLocations: [StudentLocationAnnotation]?, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in

            if let error = error {

                completionHandler(success: false, studentLocations: nil, errorString: "Get Student Locations Failed (Bad Request).")
                
            } else {
                
                var parseError: NSError? = nil
                let parseResult = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &parseError) as! NSDictionary
                
                if let results = parseResult["results"] as? [[String: AnyObject]] {
                    
                    var studentLocations = [StudentLocationAnnotation]()
                    
                    for result in results {
                        
                        let objectId = result["objectId"] as! String
                        let uniqueKey = result["uniqueKey"] as! String
                        let firstName = result["firstName"] as! String
                        let lastName = result["lastName"] as! String
                        let latitude = result["latitude"] as! Double
                        let longitude = result["longitude"] as! Double
                        let mapString = result["mapString"] as! String
                        let mediaURLString = result["mediaURL"] as! String
                        let mediaURL = NSURL(string: mediaURLString)!
                        
                        let location = StudentLocationAnnotation.StudentLocation(objectId: objectId, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL)
                        
                        studentLocations.append(StudentLocationAnnotation(studentLocation: location))
                    }
                    
                    completionHandler(success: true, studentLocations: studentLocations, errorString: nil)
                    
                } else {
                    
                    completionHandler(success: false, studentLocations: nil, errorString: "Get Student Locations Failed (No Results)")
                    
                }
            }
        }
        task.resume()
    }
}