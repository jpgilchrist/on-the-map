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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchAndUpdateStudentLocations()
    }
    
    @IBAction func fetchAndUpdateStudentLocations() {
        StudentLocationClient.sharedInstance().readStudentLocations(100) { success, studentLocations, errorString in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.studentLocations = StudentLocation.toStudentAnnotations(studentLocations)
                    self.tableView.reloadData()
                }
            } else {
                println("FAILURE \(errorString)")
            }
        }
    }
}
