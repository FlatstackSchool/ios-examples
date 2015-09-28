//
//  ResultViewController.swift
//  AFNetworkingExample
//
//  Created by Vladimir Goncharov on 25.08.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!

    var result: AnyObject! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lResult = self.result as? AFObject {
            let text = "ID - \(lResult.serverID!) \n\(lResult.attributes!)"
            self.textView.text = text
        }
        
        if let lResult = self.result as? AFImage {
            
            self.imageView.image = lResult.image
            self.textView.text = "\(lResult.name!) (ID - \(lResult.serverID!) MIME - \(lResult.mime!)))"
        }
    }
}
