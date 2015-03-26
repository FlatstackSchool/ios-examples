// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Bug.h instead.

#import <CoreData/CoreData.h>
#import "Issue.h"

extern const struct BugAttributes {
	__unsafe_unretained NSString *deadlineDate;
} BugAttributes;

@interface BugID : IssueID {}
@end

@interface _Bug : Issue {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BugID* objectID;

@property (nonatomic, strong) NSDate* deadlineDate;

//- (BOOL)validateDeadlineDate:(id*)value_ error:(NSError**)error_;

@end

@interface _Bug (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveDeadlineDate;
- (void)setPrimitiveDeadlineDate:(NSDate*)value;

@end
