//
//  CustomActivity.m
//  ActivityViewControllerExample
//
//  Created by Никита Фомин on 04.03.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

#import "CustomActivity.h"

@implementation CustomActivity

-(NSString *)activityType {
    return @"ru.osxdev.alertactivity";
}

-(NSString *)activityTitle {
    return @"Show Alert";
}

-(UIImage *)activityImage {
    return [UIImage imageNamed:@"Cute-Ball-Go-icon"];
}

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (NSObject *item in activityItems) {
        if (![item isKindOfClass:[NSString class]]) {
            return NO;
        }
    }
    return YES;
}

-(void)prepareWithActivityItems:(NSArray *)activityItems {
    self.text = @"";
    for (NSObject *item in activityItems) {
        self.text = [NSString stringWithFormat:@"%@ %@", self.text, item];
    }
}

-(void)performActivity {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"ActivityAlert"
                          message:self.text
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
    
    
    //
    // you can open here any your application
    //
    
    
    [self activityDidFinish:YES];
}

@end
