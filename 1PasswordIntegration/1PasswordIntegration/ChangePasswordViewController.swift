//
//  ChangePasswordViewController.swift
//  1PasswordIntegration
//
//  Created by Sergey Nikolaev on 17.08.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import OnePasswordExtension

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet var oldPasswordField: UITextField!
    @IBOutlet var newPasswordField: UITextField!
    
    @IBOutlet var onePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onePasswordButton.hidden = !OnePasswordExtension.sharedExtension().isAppExtensionAvailable()
    }
    
    @IBAction func onePasswordTapped(sender: AnyObject) {
        let oldPassword = self.oldPasswordField.text ?? ""
        let newPassword = self.newPasswordField.text ?? ""
        
        let loginDetails: [NSObject : AnyObject] = [
            AppExtensionTitleKey: OnePasswordConstants.Title,
            AppExtensionPasswordKey: newPassword,
            AppExtensionOldPasswordKey: oldPassword
        ]
        
        let passwordGeneratorOptions: [NSObject : AnyObject] = [
            AppExtensionGeneratedPasswordMinLengthKey: 5,
            AppExtensionGeneratedPasswordMaxLengthKey: 15,
            AppExtensionGeneratedPasswordRequireDigitsKey: true,
            AppExtensionGeneratedPasswordRequireSymbolsKey: true,
            AppExtensionGeneratedPasswordForbiddenCharactersKey: "#$"
        ]
        
        OnePasswordExtension.sharedExtension().changePasswordForLoginForURLString(OnePasswordConstants.URL, loginDetails: loginDetails, passwordGenerationOptions: passwordGeneratorOptions, forViewController: self, sender: self) {[weak self] (dict, error) in
            
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                self?.presentViewController(alert, animated: true, completion: nil)
            }
            
            guard let dict = dict else {return}
            
            self?.oldPasswordField.text = dict[AppExtensionOldPasswordKey] as? String ?? self?.oldPasswordField.text
            self?.newPasswordField.text = dict[AppExtensionPasswordKey] as? String ?? self?.newPasswordField.text
        }
    }
}
