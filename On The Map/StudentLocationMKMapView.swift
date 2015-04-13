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
        
        /* NOTE: Found that it was necessary to define delegate within the class so we have access to self (i.e., hte mapView) and therefore dequeueReusableAnnotationViewWithIdentifer */
        self.delegate = self
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        /* 1. Make sure that the annotation is our StudentLocationAnnotation (should always be true) */
        if let annotation = annotation as? StudentLocationAnnotation {
            
            /* 2. Dequeue a annotationView if one exists */
            if let annotationView = self.dequeueReusableAnnotationViewWithIdentifier(StudentLocationAnnotation.Constants.reuseIdentifier) {
                
                /* 3a. Reconfigure the resuable annotation view with the subject annotation object */
                annotationView.annotation = annotation
                
                return annotationView
            } else {
                
                /* 3b. get the computed annotationView from our StudentLocationAnnotation class */
                return annotation.annotationView
            }
        } else {
            
            /* this should never happen because we aren't adding any other types of annotations */
            return nil
        }
    }
}
