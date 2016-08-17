//
//  SignUpViewController.swift
//  1PasswordIntegration
//
//  Created by Sergey Nikolaev on 17.08.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import OnePasswordExtension

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var onePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.onePasswordButton.hidden = !OnePasswordExtension.sharedExtension().isAppExtensionAvailable()
    }
    
    @IBAction func onePasswordTapped(sender: AnyObject) {
        let firstName = self.firstnameField.text ?? ""
        let lastName = self.lastnameField.text ?? ""
        let email = self.emailField.text ?? ""
        let password = self.passwordField.text ?? ""
        
        let loginDetails: [NSObject : AnyObject] = [
            AppExtensionTitleKey: OnePasswordConstants.Title,
            AppExtensionUsernameKey: email,
            AppExtensionPasswordKey: password,
            AppExtensionNotesKey: "Saved with One Password Integration example app",
            AppExtensionFieldsKey: [
                OnePasswordConstants.Fields.firstName : firstName,
                OnePasswordConstants.Fields.lastName : lastName
            ]
        ]
        
        let passwordGeneratorOptions: [NSObject : AnyObject] = [
            AppExtensionGeneratedPasswordMinLengthKey: 5,
            AppExtensionGeneratedPasswordMaxLengthKey: 15,
            AppExtensionGeneratedPasswordRequireDigitsKey: true,
            AppExtensionGeneratedPasswordRequireSymbolsKey: true,
            AppExtensionGeneratedPasswordForbiddenCharactersKey: "#$"
        ]
        
        OnePasswordExtension.sharedExtension().storeLoginForURLString(OnePasswordConstants.URL, loginDetails: loginDetails, passwordGenerationOptions: passwordGeneratorOptions, forViewController: self, sender: self) {[weak self] (dict, error) in
            
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                self?.presentViewController(alert, animated: true, completion: nil)
            }
            
            guard let dict = dict else {return}
            
            self?.emailField.text = dict[AppExtensionUsernameKey] as? String ?? self?.emailField.text
            self?.passwordField.text = dict[AppExtensionPasswordKey] as? String ?? self?.passwordField.text
            
            if let fieldsDict = dict[AppExtensionReturnedFieldsKey] {
                self?.firstnameField.text = fieldsDict[OnePasswordConstants.Fields.firstName] as? String ?? self?.firstnameField.text
                self?.lastnameField.text = fieldsDict[OnePasswordConstants.Fields.lastName] as? String ?? self?.lastnameField.text
            }
        }
    }
    
    
}
