// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Bug.m instead.

#import "_Bug.h"

const struct BugAttributes BugAttributes = {
	.deadlineDate = @"deadlineDate",
};

@implementation BugID
@end

@implementation _Bug

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Bug" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Bug";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Bug" inManagedObjectContext:moc_];
}

- (BugID*)objectID {
	return (BugID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic deadlineDate;

@end

