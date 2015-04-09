//
//  LoginTextField.swift
//  On The Map
//
//  Created by James Gilchrist on 4/8/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {
    
    /* attributes for text field */
    //NOTE: I can't seem to set it to UIColor.whiteColor() - it disappears when I do this.
    let textAttributes: [NSObject : AnyObject] = [
        NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 19)!,
        NSForegroundColorAttributeName: UIColor.blackColor()
    ]
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /* setup text attributes */
        self.defaultTextAttributes = textAttributes
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: textAttributes)
        
        /* using a leftView to add padding in front of the text: 
            http://stackoverflow.com/questions/3727068/set-padding-for-uitextfield-with-uitextborderstylenone */
        self.leftView = UIView(frame: CGRectMake(0, 0, 10, 40))
        self.leftViewMode = UITextFieldViewMode.Always
        
        /* clear button will show when editing begins */
        self.clearButtonMode = UITextFieldViewMode.WhileEditing
    }
}
