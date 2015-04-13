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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAndUpdateStudentLocations()
    }
    
    func fetchAndUpdateStudentLocations() {
        UdacityStudentLocations.sharedInstance().getStudentLocations() { success, studentLocations, errorString in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.studentLocations = studentLocations
                    self.tableView.reloadData()
                }
            } else {
                println("FAILURE \(errorString)")
            }
        }
    }
}
