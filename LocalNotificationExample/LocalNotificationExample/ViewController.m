//
//  ViewController.m
//  LocalNotificationExample
//
//  Created by Никита Фомин on 01.02.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIApplication *app                = [UIApplication sharedApplication];
    NSArray *oldNotifications         = [app scheduledLocalNotifications];
    
    //    if ([oldNotifications count] > 0) {
    //        [app cancelAllLocalNotifications];
    //    }
    
    for (UILocalNotification *aNotif in oldNotifications) {
        if([[aNotif.userInfo objectForKey:@"ID"] isEqualToString:@"0"]) {
            [app cancelLocalNotification:aNotif];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)addNotification:(id)sender
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.timeZone  = [NSTimeZone systemTimeZone];
    notification.fireDate  = [[NSDate date] dateByAddingTimeInterval:6.0f];
    notification.alertAction = @"More info";
    notification.alertBody = @"Local Notification example";
    notification.hasAction = YES;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 10;
//    notification.repeatInterval = (NSCalendarUnitMinute | NSCalendarUnitEra);
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"0" forKey:@"id"];
    notification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (IBAction)addActionNotif:(id)sender
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.timeZone  = [NSTimeZone systemTimeZone];
    notification.fireDate  = [[NSDate date] dateByAddingTimeInterval:6.0f];
    notification.alertAction = @"More info";
    notification.alertBody = @"Action Local Notification example";
    notification.hasAction = YES;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.category = @"my_category";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (IBAction)registrActionNotif:(id)sender
{
    UIMutableUserNotificationAction *notifAction = [[UIMutableUserNotificationAction alloc] init];
    notifAction.identifier = @"justInform";
    notifAction.title = @"OK, got it";
    notifAction.activationMode = UIUserNotificationActivationModeBackground;
    notifAction.destructive = NO;
    notifAction.authenticationRequired = NO;
    
    
    UIMutableUserNotificationAction *notifActionForeground = [[UIMutableUserNotificationAction alloc] init];
    notifActionForeground.identifier = @"editList";
    notifActionForeground.title = @"Edit list";
    notifActionForeground.activationMode = UIUserNotificationActivationModeForeground;
    notifActionForeground.destructive = YES;
    notifActionForeground.authenticationRequired = YES;
    
    
    UIMutableUserNotificationAction *notifActionDelete = [[UIMutableUserNotificationAction alloc] init];
    notifActionDelete.identifier = @"trashAction";
    notifActionDelete.title = @"Delete list";
    notifActionDelete.activationMode = UIUserNotificationActivationModeBackground;
    notifActionDelete.destructive = YES;
    notifActionDelete.authenticationRequired = YES;
    
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    [category setIdentifier:@"my_category"];
    [category setActions:@[notifAction, notifActionForeground] forContext:UIUserNotificationActionContextMinimal];
    [category setActions:@[notifAction, notifActionForeground, notifActionDelete] forContext:UIUserNotificationActionContextDefault];
    
    
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:[NSSet setWithObject:category]];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}
@end
