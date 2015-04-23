//
//  EnterURLViewController.swift
//  OnTheMap
//
//  Created by James Gilchrist on 4/23/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import CoreLocation

class EnterURLViewController: UIViewController {
    
    var placemark: CLPlacemark!

    @IBOutlet weak var placemarkFormattedAddressLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: RoundedUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        placemarkFormattedAddressLabel.text = placemark.formattedAddress

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func previewButtonTouchUpInside(sender: UIButton) {
        activityIndicatorView.hidden = false
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: urlTextField.text)!) {
            let request = NSURLRequest(URL: NSURL(string: urlTextField.text)!)
            webView.loadRequest(request)
        } else {
            self.alertInvalidURLWithMessage("The URL provided cannot be opened: [\(urlTextField.text)]. Make sure you provide the scheme: http or https.")
        }
    }
    
    @IBAction func submitButtonTouchUpInside(sender: UIButton) {
        
        activityIndicatorView.hidden = false
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: urlTextField.text)!) {
            
            let user = UdacityClient.sharedInstance().user!
            
            let studentLocation = StudentLocation(
                uniqueKey: user.userID,
                firstName: user.firstName,
                lastName: user.lastName,
                mapString: placemark.formattedAddress,
                mediaURL: NSURL(string: urlTextField.text)!,
                latitude: Float(placemark.location.coordinate.latitude),
                longitude: Float(placemark.location.coordinate.longitude))
            
            StudentLocationClient.sharedInstance().createStudentLocation(studentLocation) { success, location, error in
                
                if success {
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.alertServerError(error)
                }
                
                self.activityIndicatorView.hidden = true
            }
        } else {
            self.alertInvalidURLWithMessage("The URL provided cannot be opened: [\(urlTextField.text)]. Make sure you provide the scheme: http or https.")
        }
    }
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func alertInvalidURLWithMessage(message: String) {
        self.activityIndicatorView.hidden = true
        self.webView.hidden = true
        
        var controller = UIAlertController(title: "Invalid URL", message: message, preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func alertServerError(error: NSError) {
        self.activityIndicatorView.hidden = true
        
        println(error)

        var controller = UIAlertController(title: "Server Error", message: "There was a server error!", preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
}

extension EnterURLViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
        if let userInfo = error.userInfo as? [String: AnyObject] {            
            let failingURL = userInfo["NSErrorFailingURLStringKey"] as! String
            self.alertInvalidURLWithMessage("Cannot load the following URL: \(failingURL)")
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicatorView.hidden = true
        webView.hidden = false
    }
}
