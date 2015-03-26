//
//  MasterViewController.m
//  MagicalRecordAndMantleСomparison
//
//  Created by Vladimir Goncharov on 10.03.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#if TEST_MAGICAL_RECORD

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "Person.h"
#import "Address.h"

#else

#import "CoreDataManager.h"
#import "Bug.h"
#import "GHBug.h"
#import "Issue.h"
#import "GHIssue.h"
#import "Question.h"
#import "GHQuestion.h"
#import "User.h"
#import "GHUser.h"

#endif

@interface MasterViewController ()

@property (nonatomic, strong) NSMutableArray *objects;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
#if TEST_MAGICAL_RECORD
    self.objects    = [[Person MR_findAll] mutableCopy];
#else
    
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[Issue entityName]];
    
    self.objects =
    [[[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:request
                                                                        error:&error] mutableCopy];
#endif
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
#if TEST_MAGICAL_RECORD
    Person *object = self.objects[indexPath.row];
    cell.textLabel.text = [object fullName];
#else
    Issue *object = self.objects[indexPath.row];
    cell.textLabel.text = object.title;
#endif
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
#if TEST_MAGICAL_RECORD
        __weak typeof(self) wself   = self;
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Person *person = [wself.objects[indexPath.row] MR_inContext:localContext];
            [person MR_deleteEntity];
        } completion:^(BOOL success, NSError *error) {
            if (success)
            {
                [wself.objects removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
#else
        Issue *object = self.objects[indexPath.row];
        [[[CoreDataManager sharedManager] managedObjectContext] deleteObject:object];
        [[CoreDataManager sharedManager] saveContext];
        
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
#endif
    } 
}

@end
