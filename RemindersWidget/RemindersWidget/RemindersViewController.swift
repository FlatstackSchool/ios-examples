//
//  RemindersViewController.swift
//  RemindersWidget
//
//  Created by Kruperfone on 17.03.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import UIKit
import EventKit

class RemindersViewController: UITableViewController {
    
    var store:EKEventStore!
    var calendar:EKCalendar!
    
    var reminders:[EKReminder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get incomplete remiders for current calendar
        var predicate:NSPredicate = self.store.predicateForIncompleteRemindersWithDueDateStarting(nil, ending: nil, calendars: [calendar])
        
        self.store.fetchRemindersMatchingPredicate(predicate, completion: { (events:[AnyObject]!) -> Void in
            for reminder in events {
                if let rem = reminder as? EKReminder {
                    println(reminder.title)
                }
            }
            
            self.reminders = events as! [EKReminder]
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return reminders.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell") as! ReminderCell
        
        cell.prepareCell(reminders[indexPath.row])
        
        return cell
    }
    
}
