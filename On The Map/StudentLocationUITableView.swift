//
//  StudentLocationUITableView.swift
//  On The Map
//
//  Created by James Gilchrist on 4/10/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class StudentLocationUITableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var studentLocations: [StudentLocationAnnotation]? = nil
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if studentLocations == nil {
            return 0
        } else {
            return studentLocations!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCellWithIdentifier("StudentLocationTableViewCell") as! UITableViewCell
                
        cell.textLabel?.text = studentLocations![indexPath.row].title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentLocation = studentLocations![indexPath.row]
        let url = NSURL(string: studentLocation.subtitle)!
        
        UIApplication.sharedApplication().openURL(url)
    }
    
}
