//
//  StudentLocationClientTests.swift
//  On The Map
//
//  Created by James Gilchrist on 4/16/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import XCTest

import On_The_Map

class StudentLocationClientTests: XCTestCase {
    
    var studentLocation = StudentLocation(data: [
        "uniqueKey": "1234",
        "firstName": "John",
        "lastName": "Doe",
        "mapString": "Mountain View, CA",
        "mediaURL": "https://udacity.com",
        "latitude": 37.386052,
        "longitude": -122.083851
        ])
    
    func testReadStudentLocationsWithLimit() {
        let exp = expectationWithDescription("StudentLocationClientTests.testReadStudentLocationsWithLimit")
        
        StudentLocationClient.sharedInstance().readStudentLocations(1) { success, json, error in
            XCTAssertNil(error, "\(error)")
            
            println(json)
            
            exp.fulfill()
        }
        
        waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error, "there were errors")   
        }
    }
    
    func testCreateStudentLocation() {
        let exp = expectationWithDescription("StudentLocationClientTests.testCreateStudentLocation")
        
        StudentLocationClient.sharedInstance().createStudentLocation(studentLocation) { success, json, error in
            XCTAssertNil(error, "\(error)")
            
            self.studentLocation = json
            println("RESULT \(self.studentLocation)")

            
            exp.fulfill()
        }
        
        waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error, "there were errors")
        }
    }
    
    func testUpdateStudentLocation() {
        let exp = expectationWithDescription("StudentLocationClientTests.testUpdateStudentLocation")

        studentLocation.objectId = "zdkuAdgGif"
        studentLocation.firstName = "Jayne"
        
        StudentLocationClient.sharedInstance().updateStudentLocation(studentLocation) { success, json, error in
            XCTAssertNil(error, "\(error)")
            
            self.studentLocation = json
            println("RESULT \(self.studentLocation)")
            
            exp.fulfill()
        }
        
        waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error, "there were errors")
        }
    }
    
}