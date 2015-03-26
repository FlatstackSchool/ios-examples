//
//  GHIssue.m
//  MagicalRecordAndMantleСomparison
//
//  Created by Vladimir Goncharov on 11.03.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import "GHIssue.h"

#import "Issue.h"
#import "Bug.h"
#import "Question.h"

#import "GHBug.h"
#import "GHQuestion.h"

@implementation GHIssue

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return dateFormatter;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             IssueAttributes.serverID : @"id",
             IssueAttributes.number : @"number",
             IssueAttributes.title : @"title",
             IssueAttributes.body : @"body",
             IssueAttributes.url : @"url",
             IssueAttributes.state : @"state",
             IssueAttributes.createdAt : @"created_at",
             IssueAttributes.updatedAt : @"updated_at",
             IssueRelationships.user : @"user"
             };
}



+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)stateJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"open": @(GHIssueStateOpen),
                                                                           @"closed": @(GHIssueStateClosed)
                                                                        }];
}

+ (NSValueTransformer *)createdAtJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)updatedAtJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[GHUser class]];
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary
{
    NSString *type = JSONDictionary[@"type"];
    if ([type isKindOfClass:[NSString class]])
    {
        if ([type isEqualToString:@"bug"])
        {
            return [GHBug class];
        }
        else if ([type isEqualToString:@"question"])
        {
            return [GHQuestion class];
        }
    }

    return self;
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName
{
    return [Issue entityName];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{
             IssueAttributes.serverID : IssueAttributes.serverID,
             IssueAttributes.number : IssueAttributes.number,
             IssueAttributes.title : IssueAttributes.title,
             IssueAttributes.body : IssueAttributes.body,
             IssueAttributes.url : IssueAttributes.url,
             IssueAttributes.state : IssueAttributes.state,
             IssueAttributes.createdAt : IssueAttributes.createdAt,
             IssueAttributes.updatedAt : IssueAttributes.updatedAt,
             IssueAttributes.localValue : IssueAttributes.localValue
             };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing
{
    return [NSSet setWithObjects:IssueAttributes.serverID, nil];
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{
             IssueRelationships.user : IssueRelationships.user
             };
}

#pragma mark - init

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
                             error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue
                               error:error];
    if (self)
    {
        // Store a value that needs to be determined locally upon initialization.
        self.localValue     = @(arc4random_uniform(100));
    }
    
    return self;
}

@end
