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
    
    /* login button */
    @IBOutlet weak var loginButton: UIButton!
    
    /* Sign In with Facebook Button */
    @IBOutlet weak var signInWithFacebookButton: UIButton!
    
    var client = UdacityClient.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginButtonTouchUpInside(sender: UIButton) {
        client.loginWithUsernameAndPassword(self.emailTextField.text, password: self.passwordTextField.text) { success, errorString in
            
            println("loginButtonTouchUpInside done \(success) \(errorString)")
        }
    }
    
    @IBAction func signUpButtonTouchUpInside(sender: UIButton) {
        println("TODO: Implement signUpButtonTouchUpInside")
    }
    
    @IBAction func signInWithFacebookButtonTouchUpInside(sender: AnyObject) {
        println("TODO: Implement signInWithFacebookTouchUpInside")
    }
    
    func completeLogin() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("RootTabBar") as UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
    }
}