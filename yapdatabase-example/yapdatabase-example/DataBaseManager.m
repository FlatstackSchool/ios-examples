//
//  DataBaseManager.m
//  yapdatabase-example
//
//  Created by Nikita Asabin on 04.06.15.
//  Copyright (c) 2015 Nikita Asabin. All rights reserved.
//

#import "DataBaseManager.h"
#import <YapDatabaseView.h>
#import <YapDatabaseFilteredView.h>
#import "Person.h"
#import <UIKit/UIKit.h>

NSString *const UIDatabaseConnectionWillUpdateNotification = @"UIDatabaseConnectionWillUpdateNotification";
NSString *const UIDatabaseConnectionDidUpdateNotification  = @"UIDatabaseConnectionDidUpdateNotification";
NSString *const kNotificationsKey = @"notifications";
NSString *const kCollectionName = @"test";

NSString *const Ext_View_Order = @"order";

DataBaseManager *MyDatabaseManager;

@implementation DataBaseManager

@synthesize database = database;

@synthesize uiDatabaseConnection = uiDatabaseConnection;
@synthesize bgDatabaseConnection = bgDatabaseConnection;


+ (instancetype) dataBaseManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MyDatabaseManager = [[self alloc] init];
    });
    
    return MyDatabaseManager;
}


- (void) setupDatabase
    {
        NSString *databasePath = [[self class] databasePath];
        NSLog(@"databasePath: %@", databasePath);
        
        
        // Create the database
        
        database = [[YapDatabase alloc] initWithPath:databasePath];
        
        // Setup database connection(s)
        
        uiDatabaseConnection = [database newConnection];
        uiDatabaseConnection.objectCacheLimit = 400;
        uiDatabaseConnection.metadataCacheEnabled = NO;
        
        // Setup the extensions
        
       [self setupOrderViewExtension];
        
#if YapDatabaseEnforcePermittedTransactions
        uiDatabaseConnection.permittedTransactions = YDB_SyncReadTransaction | YDB_MainThreadOnly;
#endif
        
        bgDatabaseConnection = [database newConnection];
        bgDatabaseConnection.objectCacheLimit = 400;
        bgDatabaseConnection.metadataCacheEnabled = NO;
        
        // Start the longLivedReadTransaction on the UI connection.
        
        [uiDatabaseConnection enableExceptionsForImplicitlyEndingLongLivedReadTransaction];
        [uiDatabaseConnection beginLongLivedReadTransaction];
        
    }

    
- (void)setupOrderViewExtension
{
    
    YapDatabaseViewGrouping *orderGrouping = [YapDatabaseViewGrouping withObjectBlock:
                                              ^NSString *(NSString *collection, NSString *key, id object)
                                              {
                                              
                                                  
                                                  if ([object isKindOfClass:[Person class]])
                                                  {
                                                      return @"all"; // include in view
                                                  }
                                                  
                                                  
                                                  return nil; // exclude from view
                                              }];
    
    YapDatabaseViewSorting *orderSorting = [YapDatabaseViewSorting withObjectBlock:
                                            ^(NSString *group, NSString *collection1, NSString *key1, Person *person1,
                                              NSString *collection2, NSString *key2, Person *person2)
                                            {
                                                
                                                 NSComparisonResult cmp = [person1.age compare:person2.age];
                                                
                                                if (cmp == NSOrderedAscending) return NSOrderedDescending;
                                                if (cmp == NSOrderedDescending) return NSOrderedAscending;
                                                
                                                return NSOrderedSame;
                                            }];
    
    YapDatabaseView *orderView =
    [[YapDatabaseView alloc] initWithGrouping:orderGrouping
                                      sorting:orderSorting
                                   versionTag:@"sortedByCreationDate"];
    
    [database registerExtension:orderView withName:Ext_View_Order];
    
}

+ (NSString *) databasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? paths[0] : NSTemporaryDirectory();
    
    NSString *databaseName = @"database.sqlite";
    
    return [baseDir stringByAppendingPathComponent:databaseName];
}


@end
