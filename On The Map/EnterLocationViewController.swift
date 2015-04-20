//
//  EnterLocationViewController.swift
//  On The Map
//
//  Created by James Gilchrist on 4/14/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EnterLocationViewController: UIViewController {

    @IBOutlet weak var studyingLocationTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findOnTheMapButton: RoundedUIButton!
    @IBOutlet weak var selectLocationButton: RoundedUIButton!
    
    let geocoder = CLGeocoder()
    
    var geocodedPlacemarks: [CLPlacemark]? {
        didSet {
            mapView.hidden = false
            selectLocationButton.hidden = false
            findOnTheMapButton.hidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findOnTheMapButtonTouchUpInside(sender: UIButton) {
        if let addressString = studyingLocationTextField?.text {
            geocoder.geocodeAddressString(addressString) { result, error in
                
                if let error = error {
                    println(error)
                } else {
                    self.geocodedPlacemarks = result as? [CLPlacemark]
                }
                
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
