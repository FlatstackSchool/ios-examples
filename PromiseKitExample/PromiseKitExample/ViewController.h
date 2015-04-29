//
//  ViewController.h
//  PromiseKitExample
//
//  Created by Corner room on 27/04/15.
//  Copyright (c) 2015 NikitaAsabin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *usersLabel;

- (IBAction)removeAllUsers:(id)sender;
- (IBAction)addUser:(id)sender;
@end

