//
//  Person.h
//  yapdatabase-example
//
//  Created by Nikita Asabin on 04.06.15.
//  Copyright (c) 2015 Nikita Asabin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>

@property (strong, nonatomic) NSString *personId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *age;

@end
