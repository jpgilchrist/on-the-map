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
    @IBOutlet weak var activityIndicatorView: UIView!

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
    @IBAction func cancelButtonTouchUpInside(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowEnterURL" {
            let controller = segue.destinationViewController as! EnterURLViewController
            controller.placemark = self.placemarks[self.currentIndex]
        }
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
