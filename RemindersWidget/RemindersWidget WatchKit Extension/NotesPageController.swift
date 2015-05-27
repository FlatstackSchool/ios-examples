//
//  SecondPageController.swift
//  RemindersWidget
//
//  Created by Kruperfone on 12.05.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import WatchKit
import Foundation
import EventKit

class NotesPageController: WKInterfaceController {

    @IBOutlet weak var commentLabel: WKInterfaceLabel!
    weak var reminder:EKReminder!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let reminder = context as? EKReminder {
            
            self.reminder = reminder
            
            self.prepareNotes()
        }
        
    }
    
    func prepareNotes () {
        
        if self.reminder.notes != nil {
            let height = 0.9 * self.reminder.notes.getStringHeight(UIFont.systemFontOfSize(16), width: WKInterfaceDevice.currentDevice().screenBounds.width)
            
            self.commentLabel.setHeight(height)
            self.commentLabel.setText(reminder.notes)
        } else {
        }
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func dictateTapped() {
        
        weak var wself = self
        
        var initalPhrases = ["Если получится", "Пока еще терпит", "Дедлайн был вчера"]
        
        self.presentTextInputControllerWithSuggestions(initalPhrases, allowedInputMode: WKTextInputMode.AllowEmoji) { (results:[AnyObject]!) -> Void in
            
            if let sself = wself {
                
                if results != nil && results.count > 0 {
                    var text = results[0] as! String
                    
                    sself.reminder.notes = text
                    sself.prepareNotes()
                }
                
            }
            
        }
        
    }
}
