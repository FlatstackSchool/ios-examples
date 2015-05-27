//
//  NotificationController.swift
//  RemindersWidget WatchKit Extension
//
//  Created by Kruperfone on 11.05.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import WatchKit
import Foundation
import EventKit

class NotificationController: WKUserNotificationInterfaceController {

    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var calendarLabel: WKInterfaceLabel!
    @IBOutlet weak var priorityLabel: WKInterfaceLabel!
    
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a local notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        
        completionHandler(.Custom)
    }

    
    override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a remote notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        
        println(remoteNotification)
        
        if let aps = remoteNotification["aps"] as? Dictionary<String, AnyObject>, category = aps["category"] as? String {
            switch category {
                case "ReminderNotification":
                    
                    if let alert = aps["alert"] as? Dictionary<String, AnyObject> {
                        
                        if let title = alert["body"] as? String {
                            self.titleLabel.setText(title)
                        } else {
                            self.titleLabel.setText("")
                        }
                        
                    } else {
                        self.titleLabel.setText("")
                    }
                    
                    if let calendar = remoteNotification["calendar"] as? String {
                        self.calendarLabel.setText(calendar)
                        
                        if let color = remoteNotification["color"] as? String {
                            self.calendarLabel.setTextColor(UIColor(hexString: color))
                        }
                        
                    } else {
                        self.calendarLabel.setText("")
                    }
                    
                    if let priority = remoteNotification["priority"] as? String {
                        self.priorityLabel.setText(priority)
                    } else {
                        self.priorityLabel.setText("")
                    }
                    
                break
                
            default: break
            }
        }
        
        completionHandler(.Custom)
    }
    
    @IBAction func doneTapped() {
        println("Done")
    }
    
    @IBAction func laterTapped() {
        println("Later")
    }
}