//
//  GHUser.m
//  MagicalRecordAndMantleСomparison
//
//  Created by Vladimir Goncharov on 11.03.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import "GHUser.h"

#import "User.h"

@implementation GHUser

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             UserAttributes.serverID : @"id",
             UserAttributes.firstName : @"first_name",
             UserAttributes.lastName : @"last_name",
             UserAttributes.nickName : @"nick_name",
             };
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName
{
    return [User entityName];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{
             UserAttributes.serverID : UserAttributes.serverID ,
             UserAttributes.firstName : UserAttributes.firstName,
             UserAttributes.lastName : UserAttributes.lastName,
             UserAttributes.nickName : UserAttributes.nickName,
             };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing
{
    return [NSSet setWithObjects:UserAttributes.serverID, UserAttributes.nickName, nil];
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{
             UserRelationships.issues : UserRelationships.issues
             };
}

@end
