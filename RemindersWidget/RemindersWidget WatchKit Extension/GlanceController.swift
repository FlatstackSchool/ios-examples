//
//  GlanceController.swift
//  RemindersWidget WatchKit Extension
//
//  Created by Kruperfone on 11.05.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import WatchKit
import Foundation
import EventKit

class GlanceController: WKInterfaceController {
    
    let store:EKEventStore = EKEventStore()
    var reminder:EKReminder!
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var calendarLabel: WKInterfaceLabel!
    
    @IBOutlet weak var priorityGroup: WKInterfaceGroup!
    @IBOutlet weak var priorityValueLabel: WKInterfaceLabel!
    
    @IBOutlet weak var dateGroup: WKInterfaceGroup!
    @IBOutlet weak var dateTitleLabel: WKInterfaceLabel!
    @IBOutlet weak var dateValueLabel: WKInterfaceLabel!
    
    @IBOutlet weak var leftValue: WKInterfaceLabel!
    
    private var timer:NSTimer?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.reminder = self.getCurrent()
        
        self.titleLabel.setText(reminder.title)
        
        self.preparePriority()
        self.prepareDate()
        self.prepareLeftDate()
        self.prepareCalendar()
        
        if self.timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "prepareLeftDate", userInfo: nil, repeats: true)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        
        if let timer = self.timer {
            if timer.valid {
                timer.invalidate()
            }
        }
        
        super.didDeactivate()
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
            
            if reminder.dueDate!.timeIntervalSinceNow < 0 {
                self.leftValue.setText("-\(leftTimeText)")
            } else {
                self.leftValue.setText(leftTimeText)
            }
            
            self.leftValue.setHidden(false)
            
        } else {
            self.leftValue.setHidden(true)
        }
        
    }
    
    func getCurrent () -> EKReminder {
        var calendar = EKCalendar(forEntityType: EKEntityTypeReminder, eventStore: store)
        
        calendar.title = "Список дел"
        calendar.CGColor = UIColor.blueColor().CGColor
        
        var foodDogReminder = self.createReminder("Покормить собаку", calendar: calendar)
        foodDogReminder.dueDateComponents = self.createDateComponents(fromDate: NSDate(timeIntervalSinceNow: Hour*2))
        foodDogReminder.notes = "Кормить собаку надо 2 раза в день. Она не любит сухой корм, поэтому надо варить кашу с мясом. В мясном, недалеко от дома, знакомый мясник может продать требуху подешевле. Не корми её курицей - на прошлой неделе у нее появилась аллергия"
        foodDogReminder.priority = 9
        
        return foodDogReminder
    }
    
    func createReminder (title:String, calendar:EKCalendar) -> EKReminder {
        var reminder = EKReminder(eventStore: store)
        reminder.calendar = calendar
        reminder.title = title
        return reminder
    }
    
    func createDateComponents (fromDate date:NSDate) -> NSDateComponents {
        
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        
        return components
    }
    
    
    
}
