// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Address.m instead.

#import "_Address.h"

const struct AddressAttributes AddressAttributes = {
	.addressID = @"addressID",
	.city = @"city",
	.postalCode = @"postalCode",
	.state = @"state",
	.street = @"street",
};

const struct AddressRelationships AddressRelationships = {
	.person = @"person",
};

const struct AddressUserInfo AddressUserInfo = {
	.relatedByAttribute = @"addressID",
};

@implementation AddressID
@end

@implementation _Address

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Address";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Address" inManagedObjectContext:moc_];
}

- (AddressID*)objectID {
	return (AddressID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"addressIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"addressID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic addressID;

- (int16_t)addressIDValue {
	NSNumber *result = [self addressID];
	return [result shortValue];
}

- (void)setAddressIDValue:(int16_t)value_ {
	[self setAddressID:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveAddressIDValue {
	NSNumber *result = [self primitiveAddressID];
	return [result shortValue];
}

- (void)setPrimitiveAddressIDValue:(int16_t)value_ {
	[self setPrimitiveAddressID:[NSNumber numberWithShort:value_]];
}

@dynamic city;

@dynamic postalCode;

@dynamic state;

@dynamic street;

@dynamic person;

- (NSMutableSet*)personSet {
	[self willAccessValueForKey:@"person"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"person"];

	[self didAccessValueForKey:@"person"];
	return result;
}

@end

