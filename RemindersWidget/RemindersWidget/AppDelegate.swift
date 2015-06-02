//
//  AppDelegate.swift
//  RemindersWidget
//
//  Created by Kruperfone on 16.03.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.prepareNotifications()
        
        return true
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        if let category = notification.category {
            switch category {
            case "ReminderNotification":
                println("ReminderNotification category")
                
                if let identifier = identifier {
                    println("\(identifier)")
                    
                    switch identifier {
                    case "NotNow":
                        println("Other one sended")
                        self.sendFoodDogNotification()
                        
                    default: break
                    }
                    
                }
                
            default: break
            }
        }
        
    }
    
    func sendFoodDogNotification () {
        var notif = UILocalNotification()
        notif.timeZone = NSTimeZone.systemTimeZone()
        notif.fireDate = NSDate(timeIntervalSinceNow: 5)
        notif.alertAction = "Food dog"
        notif.alertBody = "Food dog!"
        notif.hasAction = true
        notif.category = "ReminderNotification"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notif)
    }
    
    /*
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.timeZone  = [NSTimeZone systemTimeZone];
    notification.fireDate  = [[NSDate date] dateByAddingTimeInterval:6.0f];
    notification.alertAction = @"More info";
    notification.alertBody = @"Action Local Notification example";
    notification.hasAction = YES;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.category = @"my_category";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    */
    
    func applicationWillResignActive(application: UIApplication) {
        self.sendFoodDogNotification()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func prepareNotifications () {
        
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound | UIUserNotificationType.Badge, categories: [self.getNotifCategory()])
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
    }
    
    private func getNotifCategory () -> UIMutableUserNotificationCategory {
        
        var markAsFinishedAction = UIMutableUserNotificationAction()
        markAsFinishedAction.identifier = "MarkAsRead"
        markAsFinishedAction.title = "Done"
        markAsFinishedAction.activationMode = UIUserNotificationActivationMode.Background
        markAsFinishedAction.destructive = false
        markAsFinishedAction.authenticationRequired = false
        
        var notNowAction = UIMutableUserNotificationAction()
        notNowAction.identifier = "NotNow"
        notNowAction.title = "Later"
        notNowAction.activationMode = UIUserNotificationActivationMode.Background
        notNowAction.destructive = false
        notNowAction.authenticationRequired = false
        
        var category = UIMutableUserNotificationCategory()
        category.identifier = "ReminderNotification"
        category.setActions([markAsFinishedAction, notNowAction], forContext: UIUserNotificationActionContext.Minimal)
        category.setActions([markAsFinishedAction, notNowAction], forContext: UIUserNotificationActionContext.Default)
        
        return category
    }
}
