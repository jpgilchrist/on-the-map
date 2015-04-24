//
//  UserPinsViewController.swift
//  On The Map
//
//  Created by James Gilchrist on 4/21/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class UserPinsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: RoundedUIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchUsersStudentLocations()
    }
    
    func fetchUsersStudentLocations() {
        if let uniqueKey = UdacityClient.sharedInstance().user?.userID {
         
            activityIndicator.startAnimating()
            
            StudentLocationClient.sharedInstance().findStudentLocationsByUniqueKey(uniqueKey) { success, message in
                
                if success {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                } else {
                    self.alertError(title: "Download Error", message: message)
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func logoutButtonTouchUpInside(sender: UIButton) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKAccessToken.setCurrentAccessToken(nil)
        }
        UdacityClient.sharedInstance().logout() {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func editButtonTouchUpInside(sender: UIBarButtonItem) {
        if tableView.editing {
            tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
        } else {
            tableView.setEditing(true, animated: true)
            editButton.title = "Cancel"
        }
    }
    
    func alertError(#title: String, message: String) {
        var controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(controller, animated: true, completion: nil)
    }
}

extension UserPinsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if StudentLocationClient.sharedInstance().usersLocations == nil {
            return 0
        }
        return StudentLocationClient.sharedInstance().usersLocations!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LocationCell") as! UITableViewCell
        
        let location = StudentLocationClient.sharedInstance().usersLocations![indexPath.row]
        
        cell.textLabel?.text = location.mapString
        cell.detailTextLabel?.text = location.mediaURL?.absoluteString
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            self.activityIndicator.startAnimating()
            
            let locationToDelete = StudentLocationClient.sharedInstance().usersLocations![indexPath.row]
            
            StudentLocationClient.sharedInstance().destroyStudentLocationByObjectId(locationToDelete.objectId!) { success, message in
                
                if success {
                    tableView.beginUpdates()
                    
                    StudentLocationClient.sharedInstance().usersLocations!.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                    tableView.endUpdates()                    
                } else {
                    self.alertError(title: "Delete Error", message: message)
                }
                
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
