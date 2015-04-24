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
    
    struct Constants {
        static let reuseIdentifier = "StudentLocationMKAnnotationIdentifier"
    }
    
    var studentLocation: StudentLocation?
    
    override init() {
        super.init()
    }
    
    convenience init(studentLocation: StudentLocation) {
        self.init()
        self.studentLocation = studentLocation
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(self.studentLocation!.latitude!),
            longitude: CLLocationDegrees(self.studentLocation!.longitude!))
    }
    
    var title: String! {
        return "\(self.studentLocation!.firstName!) \(self.studentLocation!.lastName!)"
    }
    
    var subtitle: String! {
        return "\(self.studentLocation?.mediaURL?.absoluteString!)"
    }
    
    override var description: String {
        return "\(self.studentLocation!)"
    }
    
    var annotationView: MKPinAnnotationView {
        let annotationView = MKPinAnnotationView(annotation: self, reuseIdentifier: StudentLocationAnnotation.Constants.reuseIdentifier)
        
        annotationView.enabled = true
        annotationView.canShowCallout = true
        
        annotationView.animatesDrop = true
        
        var detailDisclosureButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        detailDisclosureButton.addTarget(self, action: "touchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
        annotationView.rightCalloutAccessoryView = detailDisclosureButton as UIView
        
        return annotationView
    }
    
    func touchUpInside(sender: UIButton) {
        if let url = studentLocation?.mediaURL {
            var didOpen = UIApplication.sharedApplication().openURL(self.studentLocation!.mediaURL!)
            
            if !didOpen {
                NSNotificationCenter.defaultCenter().postNotificationName("MalformedURL", object: nil, userInfo: ["url": url])
                
            }
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("MalformedURL", object: nil)
        }
    }
}
