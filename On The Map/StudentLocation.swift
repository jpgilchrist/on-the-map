//
//  StudentLocation.swift
//  On The Map
//
//  Created by James Gilchrist on 4/16/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation
import JSONHelper
import MapKit

public struct StudentLocation: Deserializable, Printable {
    
    public static let DateFormatString: String! = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    public var objectId: String?
    public var uniqueKey: String?
    public var firstName: String?
    public var lastName: String?
    public var mapString: String?
    public var mediaURL: NSURL?
    public var latitude: Float?
    public var longitude: Float?
    public var createdAt: NSDate?
    public var updatedAt: NSDate?
    public var ACL: AnyObject?
    
    public init(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: NSURL, latitude: Float, longitude: Float) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public init(data: [String: AnyObject]) {
        objectId  <-- data["objectId"]
        uniqueKey <-- data["uniqueKey"]
        firstName <-- data["firstName"]
        lastName  <-- data["lastName"]
        mapString <-- data["mapString"]
        mediaURL  <-- data["mediaURL"]
        latitude  <-- data["latitude"]
        longitude <-- data["longitude"]
        createdAt <-- (data["createdAt"], StudentLocation.DateFormatString)
        updatedAt <-- (data["updatedAt"], StudentLocation.DateFormatString)
        ACL <-- data["ACL"]
    }
    
    public func toDictionary() -> [String: AnyObject] {
        var dictionary = [String: AnyObject]()

        if let objectId  = objectId  { dictionary["objectId"]  = objectId  }
        if let uniqueKey = uniqueKey { dictionary["uniqueKey"] = uniqueKey }
        if let firstName = firstName { dictionary["firstName"] = firstName }
        if let lastName  = lastName  { dictionary["lastName"]  = lastName  }
        if let mapString = mapString { dictionary["mapString"] = mapString }
        if let mediaURL  = mediaURL  { dictionary["mediaURL"]  = mediaURL.absoluteString! }
        if let latitude  = latitude  { dictionary["latitude"]  = latitude  }
        if let longitude = longitude { dictionary["longitude"] = longitude }

        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = StudentLocation.DateFormatString
        
        if let createdAt = createdAt { dictionary["createdAt"] = dateFormatter.stringFromDate(createdAt) }
        if let updatedAt = updatedAt { dictionary["updatedAt"] = dateFormatter.stringFromDate(updatedAt) }
        if let ACL: AnyObject = ACL  { dictionary["ACL"]       = ACL }
        
        return dictionary
    }
    
    public var description: String {
        let data = NSJSONSerialization.dataWithJSONObject(self.toDictionary(), options: nil, error: nil)
        let prettyPrinted: AnyObject = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: nil)!
        return "\(prettyPrinted)"
    }
    
    func asStudentAnnotation() -> StudentLocationAnnotation {
        return StudentLocationAnnotation(studentLocation: self)
    }
    
    static func toStudentAnnotations(studentLocations: [StudentLocation]) -> [StudentLocationAnnotation] {
        var studentLocationAnnotations = [StudentLocationAnnotation]()
        for studentLocation in studentLocations {
            studentLocationAnnotations.append(studentLocation.asStudentAnnotation())
        }
        return studentLocationAnnotations
    }
}

extension StudentLocation {
    var fullName: String {
        return "\(firstName!) \(lastName!)"
    }
}
