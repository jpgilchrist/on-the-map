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
    
    var usersLocations:[StudentLocation]!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersLocations = [StudentLocation]()

        tableView.delegate = self
        tableView.dataSource = self
        
        facebookLoginButton.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchUsersStudentLocations()
    }
    
    func fetchUsersStudentLocations() {
        if let uniqueKey = UdacityClient.sharedInstance().user?.userID {
         
            StudentLocationClient.sharedInstance().findStudentLocationsByUniqueKey(uniqueKey) { success, locations, error in
                
                if let error = error {
                    println("error getting users locations")
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.usersLocations = locations
                        self.tableView.reloadData()
                    }
                }
            }
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
}

extension UserPinsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LocationCell") as! UITableViewCell
        
        cell.textLabel?.text = usersLocations[indexPath.row].mapString
        cell.detailTextLabel?.text = usersLocations[indexPath.row].mediaURL?.absoluteString
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let locationToDelete = self.usersLocations[indexPath.row]
            
            tableView.beginUpdates()
            
            self.usersLocations.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            tableView.endUpdates()
            
            StudentLocationClient.sharedInstance().destroyStudentLocationByObjectId(locationToDelete.objectId!) { success, error in
                
                if let error = error {
                    println("Error deleting \(error)")
                } else {
                    self.fetchUsersStudentLocations()
                }
            }
        }
    }
}

extension UserPinsViewController: FBSDKLoginButtonDelegate {
 
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //this shouldn't happen...
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
