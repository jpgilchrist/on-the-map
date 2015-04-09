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
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UdacityClient.sharedInstance().getStudentLocations() { success, studentLocations, error in
            
            if success {
                
            } else {
                
            }
            
            println("Map View Controller getStudentLocations done")
        }
        
    }

    @IBAction func refreshButtonTouchUpInside(sender: UIBarButtonItem) {
//        UdacityClient.sharedInstance().getStudentLocations() {
//            println("Map View Controller getStudentLocations done")
//        }
    }
}
