//
//  LoginViewController.swift
//  Organizr
//
//  Created by João Ricardo Bastos on 08/10/16.
//  Copyright © 2016 João Ricardo Bastos. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import KeychainSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            IQKeyboardManager.sharedManager().goNext()
        } else {
            textField.resignFirstResponder()
            loginButtonTapped(loginButton)
        }
        
        return true
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        loadingIndicator.startAnimating()
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let body = ["session" : ["email":email, "password": password]]
        
        let url = NSURL(string: "http://192.168.0.12:3000/sessions")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(body, options: [])
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // this code runs asynchronously...
            var errorMessage: String?
            
            if error != nil {
                errorMessage = "Something is going wrong with the server. Please try again later."
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let user = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                            let keychain = KeychainSwift()
                            keychain.set(String(user["auth_token"]!), forKey: "username")
                            dispatch_async(dispatch_get_main_queue()) {
                                self.performSegueWithIdentifier("loginSegue", sender: self)
                            }
                        }
                    } else {
                        errorMessage = "Invalid e-mail or password. Please try again."
                    }
                }
            }
            
            if errorMessage != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    let alertController = UIAlertController(title: "Could not sign in", message: errorMessage!, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }

            dispatch_async(dispatch_get_main_queue()) {
                self.loadingIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
}
