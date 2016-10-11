//
//  SignUpViewController.swift
//  Organizr
//
//  Created by João Ricardo Bastos on 11/10/16.
//  Copyright © 2016 João Ricardo Bastos. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SignUpViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

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
        } else {
            IQKeyboardManager.sharedManager().goNext()
        }
        
        return true
    }
    
    // MARK: Actions

    @IBAction func closeViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
