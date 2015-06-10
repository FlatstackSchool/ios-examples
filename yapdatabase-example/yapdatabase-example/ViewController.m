//
//  ViewController.m
//  yapdatabase-example
//
//  Created by Nikita Asabin on 04.06.15.
//  Copyright (c) 2015 Nikita Asabin. All rights reserved.
//

#import "ViewController.h"
#import "DataBaseManager.h"
#import <YapDatabaseViewMappings.h>
#import <YapDatabase.h>
#import <YapDatabaseTransaction.h>
#import <YapDatabaseViewConnection.h>
#import <YapDatabaseViewTransaction.h>
#import "Person.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    YapDatabaseViewMappings *mappings;
    YapDatabaseConnection *databaseConnection;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DataBaseManager dataBaseManager] setupDatabase];
    databaseConnection = [[DataBaseManager dataBaseManager] uiDatabaseConnection];
    [self setupMappings];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    __block Person* person ;
    
    [databaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        
        person = [[transaction extension:@"order"] objectAtIndexPath:indexPath withMappings:mappings];
    }];
    
    [cell.textLabel setText:person.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"age: %@", person.age]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return [mappings numberOfItemsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [mappings numberOfSections];
}

#pragma mark Working with database

- (void) setupMappings {
    [databaseConnection beginLongLivedReadTransaction];
    
    // Setup and configure our mappings
    NSArray *groups = @[@"all"];
    mappings = [[YapDatabaseViewMappings alloc] initWithGroups:groups view:@"order"];
    [mappings setIsDynamicSection:YES forGroup:@"all"];
    
    // Initialize the mappings.
    // This will allow the mappings object to get the counts per group.
    [databaseConnection readWithBlock:^(YapDatabaseReadTransaction * transaction) {
        [mappings updateWithTransaction:transaction];
    }];
    
    // Register for notifications when the database changes.
    // Our method will be invoked on the main-thread,
    // and will allow us to move our stable data-source from our existing state to an updated state.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yapDatabaseModified:)
                                                 name:YapDatabaseModifiedNotification
                                               object:[[DataBaseManager dataBaseManager] database]];
}

- (void)yapDatabaseModified:(NSNotification *)notification
{
    // Jump to the most recent commit.
    // End & Re-Begin the long-lived transaction atomically.
    // Also grab all the notifications for all the commits that I jump.
    // If the UI is a bit backed up, I may jump multiple commits.
    
    NSArray *notifications = [databaseConnection beginLongLivedReadTransaction];
    
    // Process the notification(s),
    // and get the change-set(s) as applies to my view and mappings configuration.
    
    NSArray *sectionChanges = nil;
    NSArray *rowChanges = nil;
    
    [[databaseConnection ext:@"order"] getSectionChanges:&sectionChanges
                                                  rowChanges:&rowChanges
                                            forNotifications:notifications
                                                withMappings:mappings];
    
    
    // No need to update mappings.
    // The above method did it automatically.
    
    if ([sectionChanges count] == 0 & [rowChanges count] == 0)
    {
        // Nothing has changed that affects our tableView
        return;
    }
    
    [self.tableView beginUpdates];
    
    for (YapDatabaseViewSectionChange *sectionChange in sectionChanges)
    {
        switch (sectionChange.type)
        {
            case YapDatabaseViewChangeDelete :
            {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionChange.index]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            case YapDatabaseViewChangeInsert :
            {
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionChange.index]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
        }
    }
    
    for (YapDatabaseViewRowChange *rowChange in rowChanges)
    {
        switch (rowChange.type)
        {
            case YapDatabaseViewChangeDelete :
            {
                [self.tableView deleteRowsAtIndexPaths:@[ rowChange.indexPath ]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            case YapDatabaseViewChangeInsert :
            {
                [self.tableView insertRowsAtIndexPaths:@[ rowChange.newIndexPath ]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            case YapDatabaseViewChangeMove :
            {
                [self.tableView deleteRowsAtIndexPaths:@[ rowChange.indexPath ]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView insertRowsAtIndexPaths:@[ rowChange.newIndexPath ]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            case YapDatabaseViewChangeUpdate :
            {
                [self.tableView reloadRowsAtIndexPaths:@[ rowChange.indexPath ]
                                      withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    }
    
    [self.tableView endUpdates];
}

- (IBAction)addPerson:(id)sender {
    
    if (![self.ageTextField.text isEqualToString:@""]&&![self.nameTextField.text isEqualToString:@""]) {
    
    Person* person = [[Person alloc] init];
    person.age = [NSNumber numberWithInteger:[self.ageTextField.text integerValue]];
    person.name = self.nameTextField.text;
    person.personId = [[NSUUID UUID] UUIDString];
    
    [[[DataBaseManager dataBaseManager] bgDatabaseConnection] readWriteWithBlock:^(YapDatabaseReadWriteTransaction * transaction) {
        [transaction setObject:person forKey:person.personId inCollection:@"test"];
    }];
    self.ageTextField.text = @"";
    self.nameTextField.text = @"";
    }
    [self.view endEditing:YES];
    
}


-(void)keyboardWillShow:(NSNotification *)notification {
    // Animate the current view out of the way
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self viewMovedAt:keyboardSize.height];
}

-(void)keyboardWillHide:(NSNotification *)notification {
   [self viewMovedAt:10];
}


//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)viewMovedAt:(CGFloat)height
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.bottomConstraint setConstant:height];
    }];

}

@end
