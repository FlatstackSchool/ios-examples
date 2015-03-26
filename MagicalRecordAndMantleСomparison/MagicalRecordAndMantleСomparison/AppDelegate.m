//
//  AppDelegate.m
//  MagicalRecordAndMantleСomparison
//
//  Created by Vladimir Goncharov on 10.03.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

#if TEST_MAGICAL_RECORD

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "Person.h"
#import "Address.h"

#else

#import "CoreDataManager.h"
#import "Bug.h"
#import "GHBug.h"
#import "Issue.h"
#import "GHIssue.h"
#import "Question.h"
#import "GHQuestion.h"
#import "User.h"
#import "GHUser.h"

#endif

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
#if TEST_MAGICAL_RECORD
    //setting MagicalRecord
    [MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    //register persons
    [self johnSmith];
    [self updatedJohnSmith];
    [self registerUsers];
    [self registerUsersViaOtherEndpoint];
#else
    //init manager
    [CoreDataManager sharedManager];
    
    [self registerIssues];
    [self registerIssues];
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#if TEST_MAGICAL_RECORD

#pragma mark - manage person

- (void)johnSmith
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"person" ofType:@"json"];
    
    NSError *error = nil;
    
    NSDictionary *personInfo  =
    [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path]
                                    options:NSJSONReadingAllowFragments
                                      error:&error];
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        Person *person =
        [Person MR_importFromObject:personInfo
                          inContext:localContext];
        
        NSLog(@"%s - %@", __FUNCTION__, person);
    }];
}

- (void)updatedJohnSmith
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"person_updated" ofType:@"json"];
    
    NSError *error = nil;
    
    NSDictionary *personInfo  =
    [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path]
                                    options:NSJSONReadingAllowFragments
                                      error:&error];

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        Person *person =
        [Person MR_importFromObject:personInfo
                          inContext:localContext];
        
        NSLog(@"%s - %@", __FUNCTION__, person);
    }];
}

- (void)registerUsers
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"array" ofType:@"json"];
    
    NSError *error = nil;
    
    NSArray *personsInfo  =
    [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path]
                                    options:NSJSONReadingAllowFragments
                                      error:&error];
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray *persons =
        [Person MR_importFromArray:personsInfo
                         inContext:localContext];
        
        NSLog(@"%s - %@", __FUNCTION__, persons);
    }];
}

- (void)registerUsersViaOtherEndpoint
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"array_as_persons" ofType:@"json"];
    
    NSError *error = nil;
    
    NSDictionary *personsInfo  =
    [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path]
                                    options:NSJSONReadingAllowFragments
                                      error:&error];
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray *persons =
        [Person MR_importFromArray:personsInfo[@"persons"]
                         inContext:localContext];
        
        NSLog(@"%s", __FUNCTION__);
        
        for (Person *person in persons)
        {
            NSLog(@"%@ - %@", person, [person address]);
        }
    }];
}

#else

- (void)registerIssues
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"issues" ofType:@"json"];
    
    NSError *error = nil;
    
    NSDictionary *issuesInfo    =
    [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path]
                                    options:NSJSONReadingAllowFragments
                                      error:&error];
    
    NSArray *issuesJSON         = issuesInfo[@"issues"];
    NSArray *ghIssuesList       = [MTLJSONAdapter modelsOfClass:[GHIssue class]
                                                  fromJSONArray:issuesJSON
                                                          error:&error];
    
    NSLog(@"%s", __FUNCTION__);
    
    for (GHIssue *ghIssue in ghIssuesList)
    {
        Issue *issue =
        [MTLManagedObjectAdapter managedObjectFromModel:ghIssue
                                   insertingIntoContext:[CoreDataManager sharedManager].managedObjectContext
                                                  error:&error];
        
        NSLog(@"%@", [error userInfo]);
        
        NSLog(@"%@", issue);
    }

    
    [[CoreDataManager sharedManager] saveContext];
}

#endif

@end
