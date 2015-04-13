//
//  StudentLocation.swift
//  On The Map
//
//  Created by James Gilchrist on 4/9/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import MapKit

/*
 * Class for accessing a shared source of studentLocations
 *
 */
class UdacityStudentLocations: NSObject {
    
    private var studentLocations: [StudentLocationAnnotation]? = nil
    
    func getStudentLocations(completionHandler: (success: Bool, studentLocations: [StudentLocationAnnotation]?, errorString: String?) -> Void) {
        
        if let locations = studentLocations {
            completionHandler(success: true, studentLocations: locations, errorString: nil)
        } else {
            UdacityClient.sharedInstance().getStudentLocations(completionHandler)
        }
    }
    
    class func sharedInstance() -> UdacityStudentLocations {
        struct Singleton {
            static let sharedInstance = UdacityStudentLocations()
        }
        
        return Singleton.sharedInstance
    }
}

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
        UIApplication.sharedApplication().openURL(self.studentLocation!.mediaURL)
    }
}
