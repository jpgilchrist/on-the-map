//
//  SelectLocationViewController.swift
//  On The Map
//
//  Created by James Gilchrist on 4/20/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI

class SelectLocationViewController: UIViewController {
    
    /* placemarks is instantiated by the controller performing the segue */
    var placemarks: [CLPlacemark]!
    
    /* watched variable that does the following:
            1. sets up the currentLocationLabel text values
            2. sets up the resultIndexLable text value
            3. sets the coordinate of the map view 
    */
    var currentIndex: Int = 0 {
        didSet {
            let currentPlacemark = placemarks[currentIndex]
            self.currentLocationLabel.text = currentPlacemark.formattedAddress
            self.resultIndexLabel.text = "\(self.currentIndex + 1) of \(self.placemarks.count)"
            
            self.mapView.setCenterCoordinate(currentPlacemark.location.coordinate, animated: true)
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var resultIndexLabel: UILabel!
    @IBOutlet weak var previousLocationButton: UIButton!
    @IBOutlet weak var nextLocationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* create an annotation for each placemark and add it to the map view */
        for placemark in placemarks {
            var annotation = MKPointAnnotation()
            annotation.coordinate = placemark.location.coordinate
            
            mapView.addAnnotation(annotation)
        }
        
        /* instantiate currentIndex as 0 to trigger the didSet watcher */
        currentIndex = 0
    }

    /* Increment the currentIndex iff it stays within the range of possibility (i.e., 0 to placemarks.count - 1) */
    @IBAction func nextPlacemarkButtonTouchUpInside(sender: UIButton) {
        
        if self.placemarks.count > 1 {
            if (self.currentIndex + 1) == placemarks.count {
                self.currentIndex = 0
            } else {
                self.currentIndex++
            }
            
        }
    }
    
    /* Decrement the currentIndex iff it stays within the range of possibility (i.e., 0 to placemarks.count - 1) */
    @IBAction func previousPlacemarkButtonTouchUpInside(sender: AnyObject) {
        
        if self.placemarks.count > 1 {
            if (self.currentIndex - 1) < 0 {
                self.currentIndex = self.placemarks.count - 1
            } else {
                self.currentIndex--
            }
        }
    }
    
    /* pop to root view controller (i.e., EnterLocationViewController) */
    @IBAction func cancelButtonTouchUpInside(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /* sets up an alert to ask the user for a URL to add to their stuyding location */
    @IBAction func selectLocationButtonTouchUpInside(sender: UIButton) {
        var inputURLTextField: UITextField!
        
        var enterLinkAlertController = UIAlertController(title: "Study Location Link", message: "Enter a link to be displayed where you are studying.", preferredStyle: UIAlertControllerStyle.Alert)

        /* 1. Add text field to alert view and make it accessible locally */
        enterLinkAlertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Your URL"
            inputURLTextField = textField
        }
        
        /* 2. Add "OK" action that creates a new student location */
        enterLinkAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { alertAction in
            /* 2.1) Get the text from the text field */
            if let urlString = inputURLTextField?.text {
                if let url = NSURL(string: urlString) {
                    
                    /* 2.2) Create a StudentLocation Object for the StudentLocationClient */
                    let currentUser = UdacityClient.sharedInstance().user!
                    let currentLocation = self.placemarks[self.currentIndex].location
                    let studentLocation = StudentLocation(uniqueKey: "\(currentUser.userID)", firstName: currentUser.firstName, lastName: currentUser.lastName, mapString: urlString, mediaURL: url, latitude: Float(currentLocation.coordinate.latitude), longitude: Float(currentLocation.coordinate.longitude))
                    
                    /* 2.3) Call the StudentLocationClient and create a new student location */
                    StudentLocationClient.sharedInstance().createStudentLocation(studentLocation) { success, studentLocation, error in

                        /* 2.4 If successful dismiss the current view controller: the navigation controller */
                        if success {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            //TODO: - Otherwise throw an alert somehow
                            println("There was an errror \(error)")
                        }
                    }
                }
            }
        })
        
        /* 3. Add "Cancel" action */
        enterLinkAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))

        /* 4. Present the View Controller */
        self.presentViewController(enterLinkAlertController, animated: true, completion: nil)
    }
}

//MARK: - CLPlacemark Extension

extension CLPlacemark {
    /* simple method for returning the formattedAddress
     *      NOTE: I had trouble with ABCreateStringWithAddressDictionary. It wasn't including the country even when specifiying true
     */
    var formattedAddress: String {
        if let dictionary = self.addressDictionary as? [String: AnyObject] {
            if let formattedAddress = dictionary["FormattedAddressLines"] as? [String] {
                var str = "\(formattedAddress)"
                /* remove the beginning and ending '[', ']' */
                return str.substringWithRange(Range<String.Index>(start: advance(str.startIndex, 1), end: advance(str.endIndex, -1)))
            }
        }
        /* If nothing else return the simple name of the location */
        return self.name
    }
}
