//
//  RemCell.swift
//  RemindersWidget
//
//  Created by Kruperfone on 18.03.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import UIKit
import EventKit

class RemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    private var reminder:EKReminder!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func prepareCell (rem:EKReminder) {
        reminder = rem
        
        titleLabel.text = rem.title
        if rem.dueDate != nil {
            self.startDueDateTimer()
        } else {
            leftTimeLabel.hidden = true
        }
        colorView.backgroundColor = UIColor(CGColor: rem.calendar.CGColor)
    }
    
    private func startDueDateTimer () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tick", name: "tick", object: nil)
    }
    
    func tick () {
        updateDueTime()
    }
    
    //Set date string
    private func updateDueTime () {
        
        let minute:NSTimeInterval   =   60
        let hour:NSTimeInterval     =   3600
        let day:NSTimeInterval      =   86400
        let week:NSTimeInterval     =   604800
        let year:NSTimeInterval     =   31556926
        
        var interval = abs(reminder.dueDate!.timeIntervalSinceNow)
        
        let years       =   Int(interval/year)
        let weeks       =   Int((interval%year)/week)
        let days        =   Int((interval%week)/day)
        let hours       =   Int((interval%day)/hour)
        let minutes     =   Int((interval%hour)/minute)
        let secs        =   Int(interval%minute)
        
        switch interval {
        case year...Double(CGFloat.max):
            leftTimeLabel.text = "\(years) years"
        case week...year:
            leftTimeLabel.text = "\(weeks) weeks"
        case day...week:
            leftTimeLabel.text = String(format: "%.2i d, %.2i:%.2i:%.2i", days, hours, minutes, secs)
        case 0...day:
            leftTimeLabel.text = String(format: "%.2i:%.2i:%.2i", hours, minutes, secs)
        default:
            leftTimeLabel.text = ""
        }
    }
    
}

extension EKReminder {
    var dueDate:NSDate? {
        get {
            if self.dueDateComponents != nil {
                return NSCalendar.currentCalendar().dateFromComponents(self.dueDateComponents)
            }
            return nil
        }
    }
}
