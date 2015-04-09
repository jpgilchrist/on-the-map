//
//  UdacityClientConstants.swift
//  On The Map
//
//  Created by James Gilchrist on 4/8/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        static let BaseSecureURL = "https://www.udacity.com/"
    }
    
    struct Methods {
        static let newSession = "api/session"
        static let userData = "api/users/{id}"
    }
    
}