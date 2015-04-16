//
//  ParseClientConstants.swift
//  On The Map
//
//  Created by James Gilchrist on 4/15/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation

class ParseClientConstants {
    
    struct Methods {
        static let StudentLocations = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    struct HeaderKeys {
        static let ApplicationID = "X-Parse-Application-Id"
        static let RestAPIKey = "X-Parse-REST-API-Key"
        static let Accepts = "Accepts"
        static let ContentType = "Content-Type"
    }
    
    struct HeaderValues {
        static let ApplcationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationJson = "application/json"
    }
    
    struct StudentLocationObjectKeys {
        static let ObjectID     :String = "objectId"
        static let UniqueKey    :String = "uniqueKey"
        static let FirstName    :String = "firstName"
        static let LastName     :String = "lastName"
        static let MapString    :String = "mapString"
        static let MediaURL     :String = "mediaURL"
        static let Latitude     :String = "latitude"
        static let Longitude    :String = "longitude"
        static let CreatedAt    :String = "createdAt"
        static let UpdatedAt    :String = "updatedAt"
        static let ACL          :String = "ACL"
    }
    
    struct JSONParseKeys {
        static let Results = "results"
    }
    
    struct QueryParameters {
        static let Limit = "limit"
    }
    
    struct MethodTypes {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
    }
    
}