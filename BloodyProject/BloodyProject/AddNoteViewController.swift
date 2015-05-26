//
//  AddNoteViewController.swift
//  BloodyProject
//
//  Created by Kruperfone on 25.05.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import UIKit
import HealthKit

protocol AddNoteDelegate:NSObjectProtocol {
    func saveNote (value:Double, type:NoteType)
    func cancelNote ()
}

class AddNoteViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    
    var type:NoteType?
    
    weak var delegate:AddNoteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func prepareController (type:NoteType) {
        self.type = type
        
        self.titleLabel.text = type.title
        self.unitLabel.text = type.unit
    }
    
    private func getValue () -> Double {
        let text = self.textField.text
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let number = numberFormatter.numberFromString(text)!
        
        return number.doubleValue
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.view.endEditing(true)
        self.delegate?.cancelNote()
        self.clearView()
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        self.view.endEditing(true)
        self.delegate?.saveNote(self.getValue(), type:self.type!)
        self.clearView()
    }

    func clearView () {
        self.textField.text = ""
    }
}
