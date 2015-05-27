//
//  ViewController.swift
//  RemindersWidget
//
//  Created by Kruperfone on 16.03.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import UIKit
import EventKit

class CalendarsViewController: UITableViewController {
    
    var store:EKEventStore = EKEventStore()
    var lists:[EKCalendar] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get calendars
        store.requestAccessToEntityType(EKEntityTypeReminder, completion: { (granted:Bool, error:NSError!) -> Void in
            var calendars = self.store.calendarsForEntityType(EKEntityTypeReminder)
            
            for calendar in calendars {
                if let current = calendar as? EKCalendar {
                    println(current.title)
                }
            }
            
            self.lists = calendars as! [EKCalendar]
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as! UITableViewCell!
        cell.textLabel?.text = lists[indexPath.row].title
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationController = segue.destinationViewController as? RemindersViewController {
            let index = tableView.indexPathForSelectedRow()
            
            if let index:NSIndexPath = tableView.indexPathForSelectedRow() as NSIndexPath! {
                destinationController.calendar = lists[index.row]
                destinationController.store = store
            }
        }
    }
    
}

