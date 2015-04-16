//
//  FindOnTheMapViewController.swift
//  On The Map
//
//  Created by James Gilchrist on 4/14/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import CoreLocation

class FindOnTheMapViewController: UIViewController {

    @IBOutlet weak var studyingLocationTextField: UITextField!
    
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                    if let placemarks = result as? [CLPlacemark] {
                        for placemark in placemarks {
                            println("Place Mark Location: \(placemark.location)")
                        }
                    }
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
