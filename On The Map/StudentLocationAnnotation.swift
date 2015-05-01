//
//  StudentLocationAnnotation.swift
//  On The Map
//
//  Created by James Gilchrist on 4/18/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationAnnotation: NSObject, MKAnnotation {
    
    /* reuse identifier */
    struct Constants {
        static let reuseIdentifier = "StudentLocationMKAnnotationIdentifier"
    }
    
    var studentLocation: StudentLocation!
    
    /* convenience initializer to set the studentLocaiton of this annotation */
    convenience init(studentLocation: StudentLocation) {
        self.init()
        self.studentLocation = studentLocation
    }
    
    /* returns the coordinates to place the annoation */
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(self.studentLocation.latitude!),
            longitude: CLLocationDegrees(self.studentLocation.longitude!))
    }
    
    /* returns the title to display for this annoation */
    var title: String! {
        return "\(self.studentLocation.firstName!) \(self.studentLocation.lastName!)"
    }
    
    /* returns the subtitle to display for this annotation */
    var subtitle: String! {
        if let absoluteString = self.studentLocation.mediaURL?.absoluteString {
           return "\(absoluteString)"
        } else {
            return ""
        }
        
    }
    
    /* description for debugging purposes */
    override var description: String {
        return "\(self.studentLocation!)"
    }
    
    /* sets up the view to display for this annotation */
    var annotationView: MKPinAnnotationView {
        let annotationView = MKPinAnnotationView(annotation: self, reuseIdentifier: StudentLocationAnnotation.Constants.reuseIdentifier)
        
        annotationView.enabled = true
        annotationView.canShowCallout = true
        
        annotationView.animatesDrop = true
        
        /* setup the button for the anntoation view to call touchUpInside on event TouchUpInside */
        var detailDisclosureButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        detailDisclosureButton.addTarget(self, action: "touchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
        annotationView.rightCalloutAccessoryView = detailDisclosureButton as UIView
        
        return annotationView
    }
    
    /* function to be called when button in annotation view is hit */
    func touchUpInside(sender: UIButton) {
        if let url = studentLocation.mediaURL {
            var didOpen = UIApplication.sharedApplication().openURL(self.studentLocation.mediaURL!)
            
            /* if the application wasn't able to open the URL (usually for scheme issues) it will broadcast a message to be handled by the controller */
            if !didOpen {
                NSNotificationCenter.defaultCenter().postNotificationName("MalformedURL", object: nil, userInfo: ["url": url])
            }
        } else {
            /* the URL was nil, and therefore we broadcast a message to be handled by the controller */
            NSNotificationCenter.defaultCenter().postNotificationName("MalformedURL", object: nil)
        }
    }
}
