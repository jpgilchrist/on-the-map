//
//  UdacityNSURLSessionExtension.swift
//  On The Map
//
//  Created by James Gilchrist on 4/9/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation

extension NSURLSession {
    /* helper function to automatically handle removing the 5 characters from udacity response data */
    func udacityDataTaskWithRequest(request: NSURLRequest, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)) -> NSURLSessionDataTask {
        
        return self.dataTaskWithRequest(request) { data, response, error in
            
            /* 1. Check if any data returned */
            if let data = data {

                /* 2. remove udacity's 5 padded characters */
                let udacityNormalizedData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                
                /* 3. Execute the completion handler with the udacity normalized data */
                completionHandler(udacityNormalizedData, response, error)
                
            } else {
                
                /* otherwise, there's no data and we can just execute the completion handler as is */
                completionHandler(data, response, error)
            }
        }
    }
}