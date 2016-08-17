//
//  SignInViewController.swift
//  1PasswordIntegration
//
//  Created by Sergey Nikolaev on 17.08.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import OnePasswordExtension

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var onePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onePasswordButton.hidden = !OnePasswordExtension.sharedExtension().isAppExtensionAvailable()
    }
    
    @IBAction func onePasswordButtonTapped(sender: AnyObject) {
        OnePasswordExtension.sharedExtension().findLoginForURLString(OnePasswordConstants.URL, forViewController: self, sender: self) {[weak self] (dict, error) in
            
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                self?.presentViewController(alert, animated: true, completion: nil)
            }
            
            guard let dict = dict else {return}
            
            self?.emailField.text = dict[AppExtensionUsernameKey] as? String ?? self?.emailField.text
            self?.passwordField.text = dict[AppExtensionPasswordKey] as? String ?? self?.passwordField.text
        }
    }
    
}
