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
                        print("logged in")
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
