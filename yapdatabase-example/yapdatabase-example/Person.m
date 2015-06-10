//
//  Person.m
//  yapdatabase-example
//
//  Created by Nikita Asabin on 04.06.15.
//  Copyright (c) 2015 Nikita Asabin. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)initWithCoder:(NSCoder *)decoder // NSCoding deserialization
{
    if ((self = [super init])) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.age = [decoder decodeObjectForKey:@"age"];
        self.personId = [decoder decodeObjectForKey:@"personId"];
     
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder // NSCoding serialization
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.age forKey:@"age"];
    [encoder encodeObject:self.personId forKey:@"personId"];
}

@end
