//
//  LoginViewController.swift
//  Organizr
//
//  Created by João Ricardo Bastos on 08/10/16.
//  Copyright © 2016 João Ricardo Bastos. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonTapped(sender: UIButton) {
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .Alert)
//        
//        alert.view.tintColor = UIColor.blackColor()
//        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        loadingIndicator.startAnimating();
//
//        alert.view.addSubview(loadingIndicator)
//        presentViewController(alert, animated: true, completion: nil)

        loadingIndicator.startAnimating()
        var timer = NSTimer()
        // cancel the timer in case the button is tapped multiple times
        timer.invalidate()
        
        // start the timer
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(delayedAction), userInfo: nil, repeats: false)
    }
    
    func delayedAction() {
//        dismissViewControllerAnimated(false, completion: nil)
        loadingIndicator.stopAnimating()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
