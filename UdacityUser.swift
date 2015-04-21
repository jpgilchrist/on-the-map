//
//  UdacityUser.swift
//  On The Map
//
//  Created by James Gilchrist on 4/9/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation

struct UdacityUser: Printable {
    let userID : String
    let firstName: String
    let lastName: String
    
    var description: String {
        return "UdacityUser [\(userID)] \(firstName) \(lastName)"
    }
}