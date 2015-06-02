//
//  ReminderDetailController.swift
//  RemindersWidget
//
//  Created by Kruperfone on 12.05.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import WatchKit
import Foundation
import EventKit

let Minute:NSTimeInterval   =   60
let Hour:NSTimeInterval     =   3600
let Day:NSTimeInterval      =   86400
let Week:NSTimeInterval     =   604800
let Year:NSTimeInterval     =   31556926

class ReminderDetailController: WKInterfaceController {
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var calendarLabel: WKInterfaceLabel!
    
    @IBOutlet weak var priorityGroup: WKInterfaceGroup!
    @IBOutlet weak var priorityValueLabel: WKInterfaceLabel!
    
    @IBOutlet weak var dateGroup: WKInterfaceGroup!
    @IBOutlet weak var dateTitleLabel: WKInterfaceLabel!
    @IBOutlet weak var dateValueLabel: WKInterfaceLabel!
    
    @IBOutlet weak var leftGroup: WKInterfaceGroup!
    @IBOutlet weak var leftTitleLabel: WKInterfaceLabel!
    @IBOutlet weak var leftValue: WKInterfaceLabel!
    
    @IBOutlet weak var doneButton: WKInterfaceButton!
    
    private weak var reminder:EKReminder!
    
    private var timer:NSTimer?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let reminder = context as? EKReminder {
            
            self.reminder = reminder
            
            let titleHeight = reminder.title.getStringHeight(UIFont.systemFontOfSize(16), width: WKInterfaceDevice.currentDevice().screenBounds.width)
            
            titleLabel.setHeight(titleHeight)
            titleLabel.setText(reminder.title)
            
            self.prepareCalendar()
            self.preparePriority()
            self.prepareDate()
            self.prepareLeftDate()
            
            var title = self.reminder.completed ? "Completed":"Not completed"
            self.doneButton.setTitle(title)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if self.timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "prepareLeftDate", userInfo: nil, repeats: true)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        if let timer = self.timer {
            if timer.valid {
                timer.invalidate()
            }
            
            self.timer = nil
        }
    }
    
    private func prepareCalendar () {
        
        let calendar = reminder.calendar
        
        let height = calendar.title.getStringHeight(UIFont.systemFontOfSize(14), width: WKInterfaceDevice.currentDevice().screenBounds.width)
        
        calendarLabel.setHeight(height)
        calendarLabel.setText(calendar.title)
        calendarLabel.setTextColor(UIColor(CGColor: calendar.CGColor))
    }
    
    private func preparePriority () {
        
        var priorityText = "None"
        var priorityColor = UIColor.whiteColor()
        
        switch reminder.priority {
        case 1...4:
            priorityText = "High"
            priorityColor = UIColor.redColor()
            
        case 5:
            priorityText = "Medium"
            priorityColor = UIColor.yellowColor()
            
        case 6...9:
            priorityText = "Low"
            priorityColor = UIColor.greenColor()
            
        default: break
        }
        
        self.priorityValueLabel.setText(priorityText)
        self.priorityValueLabel.setTextColor(priorityColor)
        
    }
    
    private func prepareDate () {
        
        if let date = self.reminder.dueDate {
            
            let interval = abs(reminder.dueDate!.timeIntervalSinceNow)
            
            var dateLabel = "Date:"
            var dateText = ""
            var formatter = NSDateFormatter()
            formatter.locale = NSLocale.currentLocale()
            
            let sameDay = NSCalendar.currentCalendar().compareDate(date, toDate: NSDate(), toUnitGranularity: NSCalendarUnit.CalendarUnitDay) == NSComparisonResult.OrderedSame
            
            let isTommorow = NSCalendar.currentCalendar().compareDate(date.dateByAddingTimeInterval(-Day), toDate: NSDate(), toUnitGranularity: NSCalendarUnit.CalendarUnitDay) == NSComparisonResult.OrderedSame
            
            if sameDay {
                formatter.dateFormat = "HH:mm"
                dateLabel = "Time:"
                dateText = formatter.stringFromDate(date)
                
            } else if isTommorow {
                dateLabel = "Date:"
                dateText = "Tomorrow"
                
            } else {
                formatter.dateFormat = "dd:MM:yyyy"
                dateLabel = "Date:"
                dateText = formatter.stringFromDate(date)
            }
            
            self.dateTitleLabel.setText(dateLabel)
            self.dateValueLabel.setText(dateText)
            
        } else {
//            self.dateGroup.setHeight(0)
            self.dateGroup.setHidden(true)
        }
        
    }
    
    func prepareLeftDate () {
        
        if let date = self.reminder.dueDate {
            
            var interval = abs(reminder.dueDate!.timeIntervalSinceNow)
            
            let years       =   Int(interval/Year)
            let weeks       =   Int((interval%Year)/Week)
            let days        =   Int((interval%Week)/Day)
            let hours       =   Int((interval%Day)/Hour)
            let minutes     =   Int((interval%Hour)/Minute)
            let secs        =   Int(interval%Minute)
            
            var leftTimeText = ""
            
            switch interval {
            case Year...Double(CGFloat.max):
                leftTimeText = "\(years) years"
            case Week*4...Year:
                leftTimeText = "\(Int(weeks/4)) months"
            case Week...Week*4:
                leftTimeText = "\(weeks) weeks"
            case Day...Week:
                leftTimeText = "\(days) days"
            case 0...Day:
                leftTimeText = String(format: "%.2i:%.2i:%.2i", hours, minutes, secs)
            default:
                leftTimeText = ""
            }
            
            self.leftValue.setText(leftTimeText)
            
            if reminder.dueDate!.timeIntervalSinceNow < 0 {
                self.leftTitleLabel.setText("Ago:")
            }
            
        } else {
            self.leftGroup.setHidden(true)
        }
        
    }
    
    @IBAction func doneTapped() {
        self.reminder.completed = !self.reminder.completed
        var title = self.reminder.completed ? "Completed":"Not completed"
        self.doneButton.setTitle(title)
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
