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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAndUpdateStudentLocations()
    }
    
    func fetchAndUpdateStudentLocations() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        UdacityStudentLocations.sharedInstance().getStudentLocations() { success, studentLocations, errorString in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(studentLocations)
                }
            } else {
                println("FAILURE \(errorString)")
            }
        }
    }
}
