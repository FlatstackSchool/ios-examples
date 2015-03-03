//
//  ViewController.m
//  ActivityViewControllerExample
//
//  Created by Никита Фомин on 03.03.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)simple:(id)sender {
    NSLog(@"Simple");
    
    //NSArray *items = @[@"Any text"];
    //NSArray *items = @[[NSURL URLWithString:@"http://osxdev.ru/blog/ios/72.html"]];
    NSArray *items = @[[UIImage imageNamed:@"Cute-Ball-Go-icon"]];
    
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activity.excludedActivityTypes = @[UIActivityTypePostToFlickr, UIActivityTypeMessage];
    
    activity.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        NSLog(@"End sharing");
    };
    
    [self presentViewController:activity animated:YES completion:nil];
}

- (IBAction)custom:(id)sender {
    NSLog(@"Custom");
    
    NSArray *items = @[@"Any text", @"One more", @"Nikita is iOS developer"];
    NSArray *activities = @[[[CustomActivity alloc] init]];
    
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:activities];
    activity.excludedActivityTypes = @[UIActivityTypePostToFlickr, UIActivityTypeMessage];
    
    activity.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        NSLog(@"End sharing");
    };
    
    [self presentViewController:activity animated:YES completion:nil];
}
@end
