// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Issue.m instead.

#import "_Issue.h"

const struct IssueAttributes IssueAttributes = {
	.body = @"body",
	.createdAt = @"createdAt",
	.localValue = @"localValue",
	.number = @"number",
	.serverID = @"serverID",
	.state = @"state",
	.title = @"title",
	.updatedAt = @"updatedAt",
	.url = @"url",
};

const struct IssueRelationships IssueRelationships = {
	.user = @"user",
};

@implementation IssueID
@end

@implementation _Issue

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Issue" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Issue";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Issue" inManagedObjectContext:moc_];
}

- (IssueID*)objectID {
	return (IssueID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"localValueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"localValue"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"number"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"serverIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"serverID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"stateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"state"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic body;

@dynamic createdAt;

@dynamic localValue;

- (int16_t)localValueValue {
	NSNumber *result = [self localValue];
	return [result shortValue];
}

- (void)setLocalValueValue:(int16_t)value_ {
	[self setLocalValue:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLocalValueValue {
	NSNumber *result = [self primitiveLocalValue];
	return [result shortValue];
}

- (void)setPrimitiveLocalValueValue:(int16_t)value_ {
	[self setPrimitiveLocalValue:[NSNumber numberWithShort:value_]];
}

@dynamic number;

- (int64_t)numberValue {
	NSNumber *result = [self number];
	return [result longLongValue];
}

- (void)setNumberValue:(int64_t)value_ {
	[self setNumber:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveNumberValue {
	NSNumber *result = [self primitiveNumber];
	return [result longLongValue];
}

- (void)setPrimitiveNumberValue:(int64_t)value_ {
	[self setPrimitiveNumber:[NSNumber numberWithLongLong:value_]];
}

@dynamic serverID;

- (int64_t)serverIDValue {
	NSNumber *result = [self serverID];
	return [result longLongValue];
}

- (void)setServerIDValue:(int64_t)value_ {
	[self setServerID:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveServerIDValue {
	NSNumber *result = [self primitiveServerID];
	return [result longLongValue];
}

- (void)setPrimitiveServerIDValue:(int64_t)value_ {
	[self setPrimitiveServerID:[NSNumber numberWithLongLong:value_]];
}

@dynamic state;

- (int16_t)stateValue {
	NSNumber *result = [self state];
	return [result shortValue];
}

- (void)setStateValue:(int16_t)value_ {
	[self setState:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveStateValue {
	NSNumber *result = [self primitiveState];
	return [result shortValue];
}

- (void)setPrimitiveStateValue:(int16_t)value_ {
	[self setPrimitiveState:[NSNumber numberWithShort:value_]];
}

@dynamic title;

@dynamic updatedAt;

@dynamic url;

@dynamic user;

@end

