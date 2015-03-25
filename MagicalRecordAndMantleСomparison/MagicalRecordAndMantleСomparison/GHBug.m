//
//  GHBug.m
//  MagicalRecordAndMantleСomparison
//
//  Created by Vladimir Goncharov on 11.03.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import "GHBug.h"

#import "Bug.h"

@implementation GHBug

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *JSONKeyPaths = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [JSONKeyPaths addEntriesFromDictionary:@
    {
        BugAttributes.deadlineDate : @"deadline_date",
     }];
    
    return JSONKeyPaths;
}

+ (NSValueTransformer *)deadlineDateJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName
{
    return [Bug entityName];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSMutableDictionary *managedObjectKeys = [NSMutableDictionary dictionaryWithDictionary:[super managedObjectKeysByPropertyKey]];
    [managedObjectKeys addEntriesFromDictionary:@
     {
         BugAttributes.deadlineDate : BugAttributes.deadlineDate,
     }];
    return managedObjectKeys;
}

@end
