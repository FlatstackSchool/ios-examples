//
//  ViewController.h
//  yapdatabase-example
//
//  Created by Nikita Asabin on 04.06.15.
//  Copyright (c) 2015 Nikita Asabin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(IBAction)addPerson:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

