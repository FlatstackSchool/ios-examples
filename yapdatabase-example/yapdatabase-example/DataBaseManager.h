//
//  DataBaseManager.h
//  yapdatabase-example
//
//  Created by Nikita Asabin on 04.06.15.
//  Copyright (c) 2015 Nikita Asabin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YapDatabase.h>

@interface DataBaseManager : NSObject

+ (instancetype) dataBaseManager;
- (void) setupDatabase;

@property (nonatomic, strong, readonly) YapDatabase *database;

@property (nonatomic, strong, readonly) YapDatabaseConnection *uiDatabaseConnection;
@property (nonatomic, strong, readonly) YapDatabaseConnection *bgDatabaseConnection;

@end
