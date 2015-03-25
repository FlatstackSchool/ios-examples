// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Person.m instead.

#import "_Person.h"

const struct PersonAttributes PersonAttributes = {
	.age = @"age",
	.firstName = @"firstName",
	.gender = @"gender",
	.lastName = @"lastName",
	.personID = @"personID",
	.url = @"url",
};

const struct PersonRelationships PersonRelationships = {
	.address = @"address",
};

const struct PersonUserInfo PersonUserInfo = {
	.relatedByAttribute = @"personID",
};

@implementation PersonID
@end

@implementation _Person

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Person";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Person" inManagedObjectContext:moc_];
}

- (PersonID*)objectID {
	return (PersonID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"ageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"age"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"personIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"personID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic age;

- (int16_t)ageValue {
	NSNumber *result = [self age];
	return [result shortValue];
}

- (void)setAgeValue:(int16_t)value_ {
	[self setAge:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveAgeValue {
	NSNumber *result = [self primitiveAge];
	return [result shortValue];
}

- (void)setPrimitiveAgeValue:(int16_t)value_ {
	[self setPrimitiveAge:[NSNumber numberWithShort:value_]];
}

@dynamic firstName;

@dynamic gender;

@dynamic lastName;

@dynamic personID;

- (int64_t)personIDValue {
	NSNumber *result = [self personID];
	return [result longLongValue];
}

- (void)setPersonIDValue:(int64_t)value_ {
	[self setPersonID:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitivePersonIDValue {
	NSNumber *result = [self primitivePersonID];
	return [result longLongValue];
}

- (void)setPrimitivePersonIDValue:(int64_t)value_ {
	[self setPrimitivePersonID:[NSNumber numberWithLongLong:value_]];
}

@dynamic url;

@dynamic address;

@end

