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
        
        let annotation = annotation as! StudentLocationAnnotation
        
        return annotation.annotationView
    }

}
