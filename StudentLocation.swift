//
//  StudentLocation.swift
//  On The Map
//
//  Created by James Gilchrist on 4/9/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationAnnotation: NSObject, MKAnnotation {
    
    struct Constants {
        static let reuseIdentifier = "StudentLocationMKAnnotationIdentifier"
    }
    
    struct StudentLocation: Printable {
        let objectId: String
        let uniqueKey: String
        let firstName: String
        let lastName: String
        let latitude: Double
        let longitude: Double
        let mapString: String
        let mediaURL: NSURL
        
        var description: String {
            return "\(firstName) \(lastName) at \(latitude):\(longitude)"
        }
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
        return CLLocationCoordinate2D(latitude: self.studentLocation!.latitude, longitude: self.studentLocation!.longitude)
    }
    
    var title: String! {
        return "\(self.studentLocation!.firstName) \(self.studentLocation!.lastName)"
    }
    
    var subtitle: String! {
        return "\(self.studentLocation!.mediaURL.absoluteString!)"
    }
    
    override var description: String {
        return "\(self.studentLocation)"
    }
    
    var annotationView: MKAnnotationView {
        let annotationView = MKPinAnnotationView(annotation: self, reuseIdentifier: StudentLocationAnnotation.Constants.reuseIdentifier)

        annotationView.enabled = true
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.InfoLight) as UIView
        annotationView.animatesDrop = true
        
        return annotationView
    }
    
    
}
