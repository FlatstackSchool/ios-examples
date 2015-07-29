//
//  ViewController.m
//  MKStoreKitExample
//
//  Created by Nikita Asabin on 08.07.15.
//  Copyright (c) 2015 Nikita Asabin. All rights reserved.
//

#import "ViewController.h"
#import "MKStoreKit.h"

static NSString* const productIdentifier = @"MKStoreKitExample";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)buyAppPurchases:(id)sender;
- (IBAction)restoreAppPurshases:(id)sender;
- (IBAction)checkExpiryDate:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
                                                      
                                                      NSLog(@"%@", [[MKStoreKit sharedKit] valueForKey:@"purchaseRecord"]);
                                                      
                                                      self.statusLabel.text = @"Product purchased";
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
                                                      
                                                      NSLog(@"%@", [[MKStoreKit sharedKit] valueForKey:@"purchaseRecord"]);
                                                      
                                                      self.statusLabel.text = @"Product Restored";
                                                  }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buyAppPurchases:(id)sender{
     [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:productIdentifier];
}
- (IBAction)restoreAppPurshases:(id)sender{
    
    if ([[MKStoreKit sharedKit] isProductPurchased:productIdentifier]) {
        self.statusLabel.text = @"Product Restored";
    }
    
}
- (IBAction)checkExpiryDate:(id)sender{
    
     if ([[MKStoreKit sharedKit] expiryDateForProduct:productIdentifier]) {
         self.statusLabel.text = @"Product expired";
      }
}

@end
