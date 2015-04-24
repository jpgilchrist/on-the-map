//
//  StudentLocationUITableView.swift
//  OnTheMap
//
//  Created by James Gilchrist on 4/22/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation
import UIKit

class StudentLocationUITableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if StudentLocationClient.sharedInstance().studentLocations == nil {
            return 0
        } else {
            return StudentLocationClient.sharedInstance().studentLocations!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationTableViewCell") as! UITableViewCell
        
        cell.textLabel?.text = StudentLocationClient.sharedInstance().studentLocations![indexPath.row].fullName
        cell.detailTextLabel?.text = StudentLocationClient.sharedInstance().studentLocations![indexPath.row].mediaURL?.absoluteString
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let url = StudentLocationClient.sharedInstance().studentLocations![indexPath.row].mediaURL {
            let didOpen = UIApplication.sharedApplication().openURL(url)
            
            if !didOpen {
                NSNotificationCenter.defaultCenter().postNotificationName("MalformedURL", object: nil, userInfo: ["url": url])
            }
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("MalformedURL", object: nil)
        }
    }    
}