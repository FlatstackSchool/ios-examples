#import "_Issue.h"

typedef NS_ENUM(int16_t, GHIssueState)
{
    GHIssueStateOpen,
    GHIssueStateClosed
};

@interface Issue : _Issue {}

@property (atomic) GHIssueState stateValue;

@end
