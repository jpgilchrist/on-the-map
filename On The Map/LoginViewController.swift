//
//  LoginViewController.swift
//  On The Map
//
//  Created by James Gilchrist on 4/8/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    /* Email & Password Text Fields */
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    
    /* Label for displaying error strings */
    @IBOutlet weak var debugLabel: UILabel!
    
    /* activity indicator to indicate that something is happening */
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /* login button */
    @IBOutlet weak var loginButton: UIButton!
    
    /* Sign In with Facebook Button */
    @IBOutlet weak var signInWithFacebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugLabel.text = ""
        self.activityIndicator.stopAnimating()
    }
    

    @IBAction func loginButtonTouchUpInside(sender: UIButton) {

        self.loginButton.enabled = false
        self.debugLabel.text = ""
        self.activityIndicator.startAnimating()
        
        UdacityClient.sharedInstance()
            .loginWithUsernameAndPassword(self.emailTextField.text, password: self.passwordTextField.text) { success, errorString in
                
                if success {
                    self.completeLogin()
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loginButton.enabled = true
                        self.activityIndicator.stopAnimating()
                        self.debugLabel.text = errorString!
                    }
                }
        }
    }
    
    @IBAction func signUpButtonTouchUpInside(sender: UIButton) {
        println("TODO: Implement signUpButtonTouchUpInside")
        let controller = cancelableUIAlertController(title: "Sign Up Button", message: "TODO: Implement sign up button")
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func signInWithFacebookButtonTouchUpInside(sender: AnyObject) {
        println("TODO: Implement signInWithFacebookTouchUpInside")
        let controller = cancelableUIAlertController(title: "Facebook Button", message: "TODO: Implement sign in with facebook")
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    /* Helper Function to return Alert Controller with single Cancel action */
    func cancelableUIAlertController(#title: String, message: String) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in controller.dismissViewControllerAnimated(true, completion: nil)})
        
        return controller
    }
    
    /* Login is complete so transition to the Map/List Tab Bar */
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
            self.debugLabel.text = ""
            self.loginButton.enabled = true
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("RootTabBar") as UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
}