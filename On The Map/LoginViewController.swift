//
//  LoginViewController.swift
//  On The Map
//
//  Created by James Gilchrist on 4/8/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import FBSDKLoginKit

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
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* setup facebook login button */
        facebookLoginButton.readPermissions = ["public_profile", "email"]
        facebookLoginButton.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
        debugLabel.text = ""
        activityIndicator.stopAnimating()

        if let token = FBSDKAccessToken.currentAccessToken() {
            loginWithAccessToken(token)
        }
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
                    self.handleLoginError(errorString!)
                }
        }
    }
    
    @IBAction func signUpButtonTouchUpInside(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
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
        }
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("RootTabBar") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func handleLoginError(errorString: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.loginButton.enabled = true
            self.activityIndicator.stopAnimating()
            self.debugLabel.text = errorString
        }
    }
}

/* Extend LoginViewController to handle FBSDKLoginButton delegate methods */
extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if let error = error {
            let controller = cancelableUIAlertController(title: "Facebook Login Error", message: "\(error)")
            self.presentViewController(controller, animated: true, completion: nil)
        } else if result.isCancelled {
            println("Facebook Login was cancelled")
        } else {
            if result.grantedPermissions.contains("email") && result.grantedPermissions.contains("public_profile") {
                if let token = result.token {
                    
                    loginWithAccessToken(token)
                    
                } else {
                    let controller = cancelableUIAlertController(title: "Facebook Login Error", message: "Invalid token.")
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            } else {
                let controller = cancelableUIAlertController(title: "Facebook Login Error", message: "Please enable permissions for Public Profile and Email access.")
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
    }
    
    func loginWithAccessToken(accessToken: FBSDKAccessToken) {
        self.loginButton.enabled = false
        self.activityIndicator.startAnimating()
        
        UdacityClient.sharedInstance().loginWithFacebook(accessToken.tokenString) { success, errorString in
            
            if success {
                self.completeLogin()
            } else {
                self.handleLoginError(errorString!)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
}