// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Person.h instead.

#import <CoreData/CoreData.h>

extern const struct PersonAttributes {
	__unsafe_unretained NSString *age;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *gender;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *personID;
	__unsafe_unretained NSString *url;
} PersonAttributes;

extern const struct PersonRelationships {
	__unsafe_unretained NSString *address;
} PersonRelationships;

extern const struct PersonUserInfo {
	__unsafe_unretained NSString *relatedByAttribute;
} PersonUserInfo;

@class Address;

@class NSURL;

@interface PersonID : NSManagedObjectID {}
@end

@interface _Person : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PersonID* objectID;

@property (nonatomic, strong) NSNumber* age;

@property (atomic) int16_t ageValue;
- (int16_t)ageValue;
- (void)setAgeValue:(int16_t)value_;

//- (BOOL)validateAge:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* firstName;

//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* gender;

//- (BOOL)validateGender:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lastName;

//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* personID;

@property (atomic) int64_t personIDValue;
- (int64_t)personIDValue;
- (void)setPersonIDValue:(int64_t)value_;

//- (BOOL)validatePersonID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSURL* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Address *address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;

@end

@interface _Person (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAge;
- (void)setPrimitiveAge:(NSNumber*)value;

- (int16_t)primitiveAgeValue;
- (void)setPrimitiveAgeValue:(int16_t)value_;

- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;

- (NSString*)primitiveGender;
- (void)setPrimitiveGender:(NSString*)value;

- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;

- (NSNumber*)primitivePersonID;
- (void)setPrimitivePersonID:(NSNumber*)value;

- (int64_t)primitivePersonIDValue;
- (void)setPrimitivePersonIDValue:(int64_t)value_;

- (NSURL*)primitiveUrl;
- (void)setPrimitiveUrl:(NSURL*)value;

- (Address*)primitiveAddress;
- (void)setPrimitiveAddress:(Address*)value;

@end
