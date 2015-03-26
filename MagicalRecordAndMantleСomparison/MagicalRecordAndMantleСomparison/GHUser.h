//
//  GHUser.h
//  MagicalRecordAndMantleСomparison
//
//  Created by Vladimir Goncharov on 11.03.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GHUser : MTLModel <MTLManagedObjectSerializing, MTLJSONSerializing>

@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSString* nickName;
@property (nonatomic, strong) NSNumber* serverID;

@property (nonatomic, strong) NSSet *issues;

@end
