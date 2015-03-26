//
//  DetailViewController.h
//  MagicalRecordAndMantleСomparison
//
//  Created by Vladimir Goncharov on 10.03.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

