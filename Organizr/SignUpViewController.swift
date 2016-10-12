//
//  SignUpViewController.swift
//  Organizr
//
//  Created by João Ricardo Bastos on 11/10/16.
//  Copyright © 2016 João Ricardo Bastos. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import KeychainSwift

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == confirmPasswordTextField {
            textField.resignFirstResponder()
            signUpButtonTapped(signUpButton)
        } else {
            IQKeyboardManager.sharedManager().goNext()
        }
        
        return true
    }
    
    // MARK: Actions
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        loadingIndicator.startAnimating()
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        let body = ["user" : ["email":email, "password": password, "password_confirmation": confirmPassword]]
        
        let url = NSURL(string: "http://192.168.0.12:3000/users")
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
                    if httpResponse.statusCode == 201 {
                        if let user = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                            let keychain = KeychainSwift()
                            keychain.set(String(user["auth_token"]!), forKey: "username")
                            dispatch_async(dispatch_get_main_queue()) {
                                self.performSegueWithIdentifier("loginFromSignUpSegue", sender: self)
                            }
                        }
                    } else {
                        if let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                            if let errors = json["errors"] {
                                if errors["email"]! != nil {
                                    errorMessage = "E-mail \(errors["email"]!![0])"
                                } else if errors["password"]! != nil {
                                    errorMessage = "Password \(errors["password"]!![0])"
                                } else if errors["password_confirmation"]! != nil {
                                    errorMessage = "\(errors["password_confirmation"]!![0])"
                                }
                            }
                        }
                    }
                }
            }
            
            if errorMessage != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    let alertController = UIAlertController(title: "Could not sign up", message: errorMessage!, preferredStyle: UIAlertControllerStyle.Alert)
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
    
    @IBAction func closeViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
