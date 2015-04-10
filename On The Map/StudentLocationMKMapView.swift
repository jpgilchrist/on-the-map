//
//  StudentLocationMKMapView.swift
//  On The Map
//
//  Created by James Gilchrist on 4/10/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationMKMapView: MKMapView, MKMapViewDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? StudentLocationAnnotation {
            println("annotation is a StudentLocationAnnotation")
            
            if let annotationView = self.dequeueReusableAnnotationViewWithIdentifier(StudentLocationAnnotation.Constants.reuseIdentifier) {
                
                /* setup annotationView with the current annotation */
                annotationView.annotation = annotation
                return annotationView
            } else {
                
                /* if there is no reusableAnnotationView in the queue then return the annoationView for the current annotation */
                return annotation.annotationView
            }
        } else {
            return nil
        }
    }
}
