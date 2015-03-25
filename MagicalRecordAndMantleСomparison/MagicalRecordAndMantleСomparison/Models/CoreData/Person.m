#import "Person.h"

@interface Person ()

@end

@implementation Person

//- (BOOL) shouldImport:(id)data
//{
//    return NO;
//}

//- (void) willImport:(id)data
//{
//    
//}

- (void) didImport:(id)data
{
    if (![data isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    NSDictionary *info              = data;
    NSString *homeUrlString         = info[@"home_url"];
    if ([homeUrlString isKindOfClass:[NSString class]])
    {
        self.url    = [NSURL URLWithString:homeUrlString];
    }
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", (self.firstName) ?: @"", (self.lastName) ?: @""];
}

@end
