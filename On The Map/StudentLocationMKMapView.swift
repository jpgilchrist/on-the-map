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
    
    
    //MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let annotation = annotation as! StudentLocationAnnotation
        
        return annotation.annotationView
    }

}
