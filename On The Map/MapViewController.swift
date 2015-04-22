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
}
