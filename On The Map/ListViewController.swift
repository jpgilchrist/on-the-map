//
//  ListViewController.swift
//  On The Map
//
//  Created by James Gilchrist on 4/8/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    
    @IBOutlet weak var tableView: StudentLocationUITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        activityIndicator.startAnimating()
        
        StudentLocationClient.sharedInstance().refreshStudentLocations(100) { success, message in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                self.alertWithMessage(message)
            }
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    //definitely could be more robust
    func alertWithMessage(message: String) {
        var controller = UIAlertController(title: "Download Error", message: message, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(controller, animated: true, completion: nil)
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
