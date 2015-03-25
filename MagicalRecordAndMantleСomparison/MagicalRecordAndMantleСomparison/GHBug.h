//
//  GHBug.h
//  MagicalRecordAndMantleСomparison
//
//  Created by Vladimir Goncharov on 11.03.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import "GHIssue.h"

@interface GHBug : GHIssue

@property (nonatomic, strong) NSDate* deadlineDate;

@end
