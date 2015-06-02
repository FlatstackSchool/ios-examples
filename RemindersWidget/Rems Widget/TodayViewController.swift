//
//  TodayViewController.swift
//  Rems Widget
//
//  Created by Kruperfone on 17.03.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import UIKit
import NotificationCenter
import EventKit

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    
    var store:EKEventStore = EKEventStore()
    
    @IBOutlet weak var tableView: UITableView!
    var reminders:[EKReminder] = []
    var timer:NSTimer!
    
    deinit {
        if self.timer.valid {
            self.timer.invalidate()
        }
        self.timer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTable()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "tick", userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        var newReminders = getStoredReminders()
        //Update table if reminders count is cnahged
        if newReminders.count != reminders.count {
            self.updateTable()
            completionHandler(NCUpdateResult.NewData)
            return
        }
        
        completionHandler(NCUpdateResult.NoData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        //Today widget has default insets (left). You can change it here
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func tick () {
        NSNotificationCenter.defaultCenter() .postNotificationName("tick", object: self)
    }
    
    func updateTable () {
        reminders = getReminders()
        
        preferredContentSize = CGSizeMake(self.view.frame.width, 44*CGFloat(self.reminders.count))
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("RemCell") as! RemCell
        cell.prepareCell(reminders[indexPath.row])
        
        return cell
    }
    
    func getReminders () -> [EKReminder] {
        var fetchedReminders:[EKReminder] = []
        var storedRems = getStoredReminders()
        var predicate:NSPredicate = self.store.predicateForRemindersInCalendars(self.store.calendarsForEntityType(EKEntityTypeReminder))
        
        var semaphore = dispatch_semaphore_create(0)
        
        self.store.fetchRemindersMatchingPredicate(predicate, completion: { (events:[AnyObject]!) -> Void in
            
            //Add reminders if it is stored in gtoup user defaults
            for reminder in events {
                if let rem = reminder as? EKReminder {
                    if find(storedRems, rem.calendarItemIdentifier) != nil {
                        fetchedReminders.append(rem)
                    }
                }
            }
            dispatch_semaphore_signal(semaphore)
        })
        
        //Wait for fetching reminders
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        return fetchedReminders
    }
    
    //Get calendar ids from group user defaults
    private func getStoredReminders () -> Array<String> {
        var pref = NSUserDefaults(suiteName: "group.todayReminderWidget")!
        
        if let reminders = pref.objectForKey("reminders") as? Array<String> {
            return reminders
        }
        
        return []
    }
}
