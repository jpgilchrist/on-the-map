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
    @IBOutlet weak var findOnTheMapButton: RoundedUIButton!
    
    /* CLGeocoder for forward encoding the location string entered later */
    let geocoder = CLGeocoder()
    
    /* forward geocode the text in studyingLocationTextField */
    @IBAction func findOnTheMapButtonTouchUpInside(sender: UIButton) {
        if let addressString = studyingLocationTextField?.text {
            geocoder.geocodeAddressString(addressString) { result, error in
                if let error = error {
                    //TODO: - Alert user of error
                    println(error)
                } else {
                    /* Segue to SelectLocationViewController with an array of CLPlacemark */
                    self.performSegueWithIdentifier("ShowSelectLocation", sender: (result as! [CLPlacemark]))
                }
                
            }
        }
    }
    
    /* dismiss the view controller: the navigation controller */
    @IBAction func cancelButtonTouchUpInside(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? SelectLocationViewController {
            dvc.placemarks = sender as! [CLPlacemark]
        }
    }

}
