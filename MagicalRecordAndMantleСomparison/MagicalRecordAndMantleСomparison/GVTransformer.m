//
//  GVTransformer.m
//  Helper
//
//  Created by Vladimir Goncharov on 21.04.14.
//  Copyright (c) 2014 FlatStack. All rights reserved.
//

#import "GVTransformer.h"

@implementation UIImagePNGToNSDataTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    return [[UIImage alloc] initWithData:value];
}

@end

@implementation NSCodingObjectToNSDataTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end