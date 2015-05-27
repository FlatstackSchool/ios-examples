//
//  ReminderCell.swift
//  RemindersWidget
//
//  Created by Kruperfone on 17.03.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import UIKit
import EventKit

class ReminderCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showSwitch: UISwitch!
    
    private var reminder:EKReminder!
    
    //Get group user defaults (for iOS app and for extension)
    private var pref:NSUserDefaults = NSUserDefaults(suiteName: "group.todayReminderWidget")!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepareCell (reminder:EKReminder) {
        println(reminder.calendarItemIdentifier)
        self.reminder = reminder
        if reminderIsStored() {
            showSwitch.setOn(true, animated: false)
        }
        
        titleLabel.text = reminder.title
    }
    
    @IBAction func switchValueChanged(sender: AnyObject) {
        var reminders = getReminders()
        
        if showSwitch.on {
            if !reminderIsStored() {
                reminders.append(reminder.calendarItemIdentifier)
            }
        } else {
            if let index = find(reminders, reminder.calendarItemIdentifier) as Int! {
                reminders.removeAtIndex(index)
            }
        }
        
        saveReminders(reminders)
    }
    
    //MARK: Helpers
    
    private func reminderIsStored () -> Bool {
        
        if let let reminders = pref.objectForKey("reminders") as? Array<String> {
            return contains(reminders, reminder.calendarItemIdentifier)
        }
        
        return false
    }
    
    private func getReminders () -> Array<String> {
        
        if let reminders = pref.objectForKey("reminders") as? Array<String> {
            return reminders
        }
        
        return []
    }
    
    private func saveReminders (rems:Array<String>) {
        pref.setObject(rems, forKey: "reminders")
        pref.synchronize()
    }
}
