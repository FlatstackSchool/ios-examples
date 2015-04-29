//
//  ViewController.m
//  PromiseKitExample
//
//  Created by Corner room on 27/04/15.
//  Copyright (c) 2015 NikitaAsabin. All rights reserved.
//

#import "ViewController.h"
#import <PromiseKit.h>
#import "CoreData/Entities/User.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [self showUser];
    [super viewDidLoad];
}

- (PMKPromise*)createUser:(NSString *)name {
   return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
       if ([name isEqualToString:@""]) {
           NSError*error = [[NSError alloc] initWithDomain:@"No name" code:0 userInfo:nil];
           reject(error);
       }else{
           User* person = [User MR_createEntity];
           person.name = name;
           person.age = @30;
           [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
               if (success) {
                   fulfill(@"Saved");
               }else{
                   reject(error);
               }
           }];
       }
       
   }];
}

- (IBAction)addUser:(id)sender {
    [self createUser:self.nameTextField.text].then(^{
        UIAlertView*alert = [[UIAlertView alloc] initWithTitle:nil message:@"User created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }).catch(^(NSError*error){
       UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }).finally(^{
        self.nameTextField.text = @"";
        [self showUser];
    });
}

- (void)showUser {
    NSArray* users =  [User MR_findAll];
    NSString*str =@"";
    for (User * person in users) {
        str = [[str stringByAppendingString:person.name] stringByAppendingString:@"\n"];
    }
    self.usersLabel.text = str;
    
}

- (IBAction)removeAllUsers:(id)sender {
    [UILabel promiseWithDuration:0.3 animations:^{
        CGRect frame = self.usersLabel.frame;
        frame.origin.x = frame.origin.x-600;
        self.usersLabel.frame = frame;
    }].then(^{
         [User MR_truncateAll];
         self.usersLabel.text = @"";
    }).finally(^{
        CGRect frame = self.usersLabel.frame;
        frame.origin.x = frame.origin.x+600;
        self.usersLabel.frame = frame;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
