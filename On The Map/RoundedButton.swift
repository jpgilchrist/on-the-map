//
//  RoundedButton.swift
//  On The Map
//
//  Created by James Gilchrist on 4/14/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation
import UIKit

class RoundedUIButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5.0
        self.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)

    }
}