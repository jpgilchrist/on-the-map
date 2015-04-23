//
//  MapViewController.swift
//  On The Map
//
//  Created by James Gilchrist on 4/8/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: StudentLocationMKMapView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAndUpdateStudentLocations()
        
        startListeningForMalformedURLNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopListeningForMalformedURLNotification()
    }
    
    @IBAction func fetchAndUpdateStudentLocations() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        StudentLocationClient.sharedInstance().readStudentLocations(100) { success, studentLocations, errorString in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(StudentLocation.toStudentAnnotations(studentLocations))
                }
            } else {
                println("FAILURE \(errorString)")
            }
        }
    }
    
    func startListeningForMalformedURLNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleMalformedURL:", name: "MalformedURL", object: nil)
    }
    
    func stopListeningForMalformedURLNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "MalformedURL", object: nil)
    }
    
    func handleMalformedURL(notification: NSNotification) {
        
        var message: String!
        if let userInfo = notification.userInfo {
            let url = userInfo["url"] as! NSURL
            message = "Oops. Cannot open the url: \(url.absoluteString!). It appears to be malformed."
        } else {
            message = "Oops. There's no URL associated with this location."
        }
        
        var alertController = UIAlertController(title: "Invalid URL", message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}
