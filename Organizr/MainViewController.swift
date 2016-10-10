//
//  MainViewController.swift
//  Organizr
//
//  Created by João Ricardo Bastos on 10/10/16.
//  Copyright © 2016 João Ricardo Bastos. All rights reserved.
//

import UIKit
import KeychainSwift

class MainViewController: UIViewController {

    // MARK: Properties

    var keychain = KeychainSwift()
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        let username = keychain.get("username")
        usernameLabel.text = username
    }

    @IBAction func logoutButtonTapped(sender: UIButton) {
        keychain.delete("username")
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        UIApplication.sharedApplication().keyWindow?.rootViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
    }
}
