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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersLocations = [StudentLocation]()

        tableView.delegate = self
        tableView.dataSource = self
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UserPinsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return usersLocations.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("LoginButtonCell") as! UITableViewCell
            
            var facebookLoginButton = FBSDKLoginButton()
            facebookLoginButton.delegate = self
            
            cell.addSubview(facebookLoginButton)
            facebookLoginButton.center = CGPoint(x: view.bounds.width / 2.0, y: 22.0)
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("LocationCell") as! UITableViewCell
            
            let location = usersLocations[indexPath.row]
            
            cell.textLabel?.text = location.mapString
            cell.detailTextLabel?.text = location.mediaURL?.absoluteString
        }
        
        return cell
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
