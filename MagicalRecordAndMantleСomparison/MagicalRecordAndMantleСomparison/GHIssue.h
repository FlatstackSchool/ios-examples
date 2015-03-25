//
//  GHIssue.h
//  MagicalRecordAndMantleСomparison
//
//  Created by Vladimir Goncharov on 11.03.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "GHUser.h"

@interface GHIssue : MTLModel <MTLManagedObjectSerializing, MTLJSONSerializing>

+ (NSDateFormatter *)dateFormatter;

@property (nonatomic, strong) NSString* body;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSNumber* number;
@property (nonatomic, strong) NSNumber* serverID;
@property (nonatomic, strong) NSNumber* state;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSDate* updatedAt;
@property (nonatomic, strong) NSURL* url;

@property (nonatomic, strong) NSNumber* localValue;

@property (nonatomic, strong) GHUser *user;

@end
