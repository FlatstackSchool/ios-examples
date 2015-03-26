//
//  GHQuestion.m
//  MagicalRecordAndMantleСomparison
//
//  Created by Vladimir Goncharov on 11.03.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import "GHQuestion.h"

#import "Question.h"

@implementation GHQuestion

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *JSONKeyPaths = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [JSONKeyPaths addEntriesFromDictionary:@
     {
         QuestionAttributes.answerTitle : @"answer",
     }];
    
    return JSONKeyPaths;
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName
{
    return [Question entityName];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSMutableDictionary *managedObjectKeys = [NSMutableDictionary dictionaryWithDictionary:[super managedObjectKeysByPropertyKey]];
    [managedObjectKeys addEntriesFromDictionary:@
     {
         QuestionAttributes.answerTitle : QuestionAttributes.answerTitle,
     }];
    return managedObjectKeys;
}

@end
