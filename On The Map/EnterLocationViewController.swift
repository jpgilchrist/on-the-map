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
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorLabel: UILabel!
    
    /* CLGeocoder for forward encoding the location string entered later */
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.hidden = true
        
        self.studyingLocationTextField.delegate = self
    }
    
    /* forward geocode the text in studyingLocationTextField */
    @IBAction func findOnTheMapButtonTouchUpInside(sender: UIButton) {
        if let addressString = studyingLocationTextField?.text {
            
            activityIndicatorView.hidden = false
            findOnTheMapButton.hidden = true
            
            geocoder.geocodeAddressString(addressString) { result, error in
                if let error = error {
                    self.alertGeocodeError(error)
                } else {
                    /* Segue to SelectLocationViewController with an array of CLPlacemark */
                    self.performSegueWithIdentifier("ShowSelectLocation", sender: (result as! [CLPlacemark]))
                }
                self.activityIndicatorView.hidden = true
                self.findOnTheMapButton.hidden = false
            }
        }
    }
    
    func alertGeocodeError(error: NSError) {
        var controller = UIAlertController(title: "Location Error", message: "The location couldn't be geocoded. Try a different address string", preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    /* dismiss the view controller: the navigation controller */
    @IBAction func cancelButtonTouchUpInside(sender: UIBarButtonItem) {
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

extension EnterLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
