//
//  StudentLocationStruct.swift
//  On The Map
//
//  Created by James Gilchrist on 4/15/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation

struct StudentLocation: Printable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: NSURL
    let latitude: Float
    let longitude: Float
    let createdAt: AnyObject
    let updatedAt: AnyObject
    let ACL: AnyObject?
    
    init(dictionary: NSDictionary) {
        self.objectId  = dictionary.valueForKey(ParseClient.StudentLocationObjectKeys.ObjectID)  as! String
        self.uniqueKey = dictionary.valueForKey(ParseClient.StudentLocationObjectKeys.UniqueKey) as! String
        self.firstName = dictionary.valueForKey(ParseClient.StudentLocationObjectKeys.FirstName) as! String
        self.lastName  = dictionary.valueForKey(ParseClient.StudentLocationObjectKeys.LastName)  as! String
        self.mapString = dictionary.valueForKey(ParseClient.StudentLocationObjectKeys.MapString) as! String
        self.mediaURL  = NSURL(string: dictionary.valueForKey(ParseClient.StudentLocationObjectKeys.MediaURL) as! String)!
        self.latitude  = dictionary.valueForKey(ParseClient.StudentLocationObjectKeys.Latitude)  as! Float
        self.longitude = dictionary.valueForKey(ParseClient.StudentLocationObjectKeys.Longitude) as! Float
        self.createdAt = dictionary.valueForKey(ParseClient.StudentLocationObjectKeys.CreatedAt)!
        self.updatedAt = dictionary.valueForKey(ParseClient.StudentLocationObjectKeys.UpdatedAt)!
        self.ACL       = dictionary.valueForKey(ParseClient.StudentLocationObjectKeys.ACL)
    }
    
    init(dictionary: [String: AnyObject]) {
        let dictionary = dictionary as NSDictionary
        self.init(dictionary: dictionary)
    }
    
    func httpBody() -> (NSData?, NSError?) {
        let jsonObject: [String: AnyObject] = [
            ParseClient.StudentLocationObjectKeys.UniqueKey: self.uniqueKey,
            ParseClient.StudentLocationObjectKeys.FirstName: self.firstName,
            ParseClient.StudentLocationObjectKeys.LastName: self.lastName,
            ParseClient.StudentLocationObjectKeys.MapString: self.mapString,
            ParseClient.StudentLocationObjectKeys.MediaURL: self.mediaURL.absoluteString!,
            ParseClient.StudentLocationObjectKeys.Latitude: self.latitude,
            ParseClient.StudentLocationObjectKeys.Longitude: self.longitude
        ]
        
        var jsonWriteError: NSError? = nil
        let data = NSJSONSerialization.dataWithJSONObject(jsonObject, options: nil, error: &jsonWriteError)
        
        return (data, jsonWriteError)
    }
    
    var description: String {
        return "{\"\(ParseClient.StudentLocationObjectKeys.ObjectID)\": \"\(self.objectId)\"}"
    }
}
