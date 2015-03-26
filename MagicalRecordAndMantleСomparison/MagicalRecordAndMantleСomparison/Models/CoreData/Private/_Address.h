// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Address.h instead.

#import <CoreData/CoreData.h>

extern const struct AddressAttributes {
	__unsafe_unretained NSString *addressID;
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *postalCode;
	__unsafe_unretained NSString *state;
	__unsafe_unretained NSString *street;
} AddressAttributes;

extern const struct AddressRelationships {
	__unsafe_unretained NSString *person;
} AddressRelationships;

extern const struct AddressUserInfo {
	__unsafe_unretained NSString *relatedByAttribute;
} AddressUserInfo;

@class Person;

@interface AddressID : NSManagedObjectID {}
@end

@interface _Address : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) AddressID* objectID;

@property (nonatomic, strong) NSNumber* addressID;

@property (atomic) int16_t addressIDValue;
- (int16_t)addressIDValue;
- (void)setAddressIDValue:(int16_t)value_;

//- (BOOL)validateAddressID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* city;

//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* postalCode;

//- (BOOL)validatePostalCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* state;

//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* street;

//- (BOOL)validateStreet:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *person;

- (NSMutableSet*)personSet;

@end

@interface _Address (PersonCoreDataGeneratedAccessors)
- (void)addPerson:(NSSet*)value_;
- (void)removePerson:(NSSet*)value_;
- (void)addPersonObject:(Person*)value_;
- (void)removePersonObject:(Person*)value_;

@end

@interface _Address (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAddressID;
- (void)setPrimitiveAddressID:(NSNumber*)value;

- (int16_t)primitiveAddressIDValue;
- (void)setPrimitiveAddressIDValue:(int16_t)value_;

- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;

- (NSString*)primitivePostalCode;
- (void)setPrimitivePostalCode:(NSString*)value;

- (NSString*)primitiveState;
- (void)setPrimitiveState:(NSString*)value;

- (NSString*)primitiveStreet;
- (void)setPrimitiveStreet:(NSString*)value;

- (NSMutableSet*)primitivePerson;
- (void)setPrimitivePerson:(NSMutableSet*)value;

@end
