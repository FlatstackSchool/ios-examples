// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Question.h instead.

#import <CoreData/CoreData.h>
#import "Issue.h"

extern const struct QuestionAttributes {
	__unsafe_unretained NSString *answerTitle;
} QuestionAttributes;

@interface QuestionID : IssueID {}
@end

@interface _Question : Issue {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) QuestionID* objectID;

@property (nonatomic, strong) NSString* answerTitle;

//- (BOOL)validateAnswerTitle:(id*)value_ error:(NSError**)error_;

@end

@interface _Question (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAnswerTitle;
- (void)setPrimitiveAnswerTitle:(NSString*)value;

@end
