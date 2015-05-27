//
//  InterfaceController.swift
//  RemindersWidget WatchKit Extension
//
//  Created by Kruperfone on 11.05.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import WatchKit
import Foundation
import EventKit

class ReminderRow : NSObject {
    
    @IBOutlet weak var textLabel: WKInterfaceLabel!
    @IBOutlet weak var priorityLabel: WKInterfaceLabel!
    
    func prepareRow (reminder:EKReminder) {
        
        var priorityText = ""
        
        if reminder.priority > 0 {
            
            switch reminder.priority {
            case 1...4:
                priorityText = "!!!"
                
            case 5:
                priorityText = "!!"
                
            case 6...9:
                priorityText = "!"
                
            default: break
            }
            
        }
        
        var fontSize:Float = 16
        var showPriority = true
        
        if let settings = NSUserDefaults.standardUserDefaults().objectForKey(kSettings) as? Dictionary<String, AnyObject> {
            
            if let fontHeight = settings[kSettingsFontSize] as? Float {
                fontSize = 13+fontHeight
            }
            
            if let showingPriority = settings[kSettingsShowPriority] as? Bool {
                showPriority = showingPriority
            }
        }
        
        var reminderTitle = NSAttributedString(string: reminder.title, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(fontSize))])
        
        var priorityTitle = NSAttributedString(string: priorityText, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(fontSize))])
        
        textLabel.setAttributedText(reminderTitle)
        textLabel.setTextColor(UIColor(CGColor: reminder.calendar.CGColor))
        
        if showPriority {
            let width = priorityText.getStringWidth(UIFont.systemFontOfSize(CGFloat(fontSize)), height: 25)+2
            priorityLabel.setWidth(width)
            priorityLabel.setText(priorityText)
        } else {
            priorityLabel.setWidth(0)
            priorityLabel.setHidden(true)
        }
        
    }
    
}

class InterfaceController: WKInterfaceController {
    
    enum FilterRule:Int {
        case Uncompleted = 0
        case Completed = 1
        case All = 2
    }
    
    var remindersCalendar:EKCalendar!
    var familyCalendar:EKCalendar!
    var workCalendar:EKCalendar!
    
    let store:EKEventStore = EKEventStore()
    @IBOutlet weak var table: WKInterfaceTable!
    
    var remindersAll:[EKReminder] = []
    var reminders:[EKReminder] {
        var filteredReminders = self.remindersAll.filter { (rem:EKReminder) -> Bool in
            switch self.filterRule {
            case FilterRule.Uncompleted: return !rem.completed
            case FilterRule.Completed: return rem.completed
            case FilterRule.All: return true
            }
        }
        return filteredReminders
    }
    var filterRule = FilterRule(rawValue: 0)!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.createReminders()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.prepareCells()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func prepareCells () {
        
        table.setNumberOfRows(self.reminders.count, withRowType: "ReminderCell")
        
        for var i = 0; i < self.reminders.count; i++ {
            (table.rowControllerAtIndex(i) as! ReminderRow).prepareRow(self.reminders[i])
        }
    }
    
    func createReminders () {
        
        self.prepareFirstCalendar()
        self.prepareSecondCalendar()
        self.prepareThirdCalendar()
        
        self.prepareCells()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let reminder = self.reminders[rowIndex]
        
        var names = ["Reminder", "ReminderNotesPage"]
        var contexts = [reminder, reminder]
        self.presentControllerWithNames(names, contexts: contexts)
    }
    
    //MARK: - Menu
    
    @IBAction func uncompletedTapped() {
        
        self.filterRule = FilterRule.Uncompleted
        self.prepareCells()
    }
    
    
    @IBAction func completedTapped() {
        self.filterRule = FilterRule.Completed
        self.prepareCells()
    }
    
    @IBAction func addTapped() {
        
        var initalPhrases = ["Встреча", "Совещание", "День рождения"]
        
        weak var wself = self
        
        self.presentTextInputControllerWithSuggestions(initalPhrases, allowedInputMode: WKTextInputMode.AllowEmoji) { (results:[AnyObject]!) -> Void in
            
            if let sself = wself {
                
                if results != nil && results.count > 0 {
                    var title = results[0] as! String
                    
                    var reminder = sself.createReminder(title, calendar: self.remindersCalendar)
                    sself.remindersAll.append(reminder)
                    
                    sself.prepareCells()
                }
                
            }
            
        }
        
    }
    
    @IBAction func settingsTapped() {
        self.presentControllerWithName("SettingsController", context: nil)
    }
    
    //MARK: - Create Reminders
    
    func prepareFirstCalendar () {
        self.remindersCalendar = EKCalendar(forEntityType: EKEntityTypeReminder, eventStore: store)
        
        self.remindersCalendar.title = "Список дел"
        self.remindersCalendar.CGColor = UIColor.blueColor().CGColor
        
        var foodDogReminder = self.createReminder("Покормить собаку", calendar: self.remindersCalendar)
        foodDogReminder.dueDateComponents = self.createDateComponents(fromDate: NSDate(timeIntervalSinceNow: Hour*2))
        foodDogReminder.notes = "Кормить собаку надо 2 раза в день. Она не любит сухой корм, поэтому надо варить кашу с мясом. В мясном, недалеко от дома, знакомый мясник может продать требуху подешевле. Не корми её курицей - на прошлой неделе у нее появилась аллергия"
        foodDogReminder.priority = 9
        
        self.remindersAll.append(foodDogReminder)
        
        var paydayReminder = self.createReminder("Заплатить за квартиру", calendar: self.remindersCalendar)
        paydayReminder.priority = 1
        
        self.remindersAll.append(paydayReminder)
    }
    
    func prepareSecondCalendar () {
        
        self.familyCalendar = EKCalendar(forEntityType: EKEntityTypeReminder, eventStore: store)
        
        self.familyCalendar.title = "Семья"
        self.familyCalendar.CGColor = UIColor.greenColor().CGColor
        
        var bDayReminder = self.createReminder("Д/р у тещи", calendar: self.familyCalendar)
        bDayReminder.dueDateComponents = self.createDateComponents(fromDate: NSDate(timeIntervalSinceNow: Week + Day+2 * Hour + 22 * Minute))
        bDayReminder.notes = "Я не уверен, что она хотела бы получить в подарок... Кажется у них сломалась хлебопечка..?"
        bDayReminder.priority = 5
        
        self.remindersAll.insert(bDayReminder, atIndex: 1)
        
        var doorsReminder = self.createReminder("Забрать двери", calendar: self.familyCalendar)
        doorsReminder.dueDateComponents = self.createDateComponents(fromDate: NSDate(timeIntervalSinceNow: -Week + Day+2 * Hour + 22 * Minute))
        doorsReminder.completed = true
        
        self.remindersAll.insert(doorsReminder, atIndex: 0)
        
    }
    
    func prepareThirdCalendar () {
        
        self.workCalendar = EKCalendar(forEntityType: EKEntityTypeReminder, eventStore: store)
        
        self.workCalendar.title = "Работа"
        self.workCalendar.CGColor = UIColor.redColor().CGColor
        
        var standupReminder = self.createReminder("Совещание", calendar: self.workCalendar)
        standupReminder.dueDateComponents = self.createDateComponents(fromDate: NSDate(timeIntervalSinceNow: Hour + 17 * Minute))
        standupReminder.notes = "Время совещаний перенесли, поскольку не было свободных совещалок"
        
        self.remindersAll.insert(standupReminder, atIndex: 2)
        
        var studyReminder = self.createReminder("Обучение", calendar: self.workCalendar)
        studyReminder.dueDateComponents = self.createDateComponents(fromDate: NSDate(timeIntervalSinceNow: 4*Hour + 34 * Minute))
        studyReminder.notes = "Я обещал рассказать про WatchKit на обучении"
        
        self.remindersAll.append(studyReminder)
        
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
