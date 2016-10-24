#import "Notification.h"
#import "NSDictionary-Expanded.h"

@interface Notification ()

@end

@implementation Notification

- (void)loadFromDictionary:(NSDictionary*)dictionary
{
    [self setUid:[dictionary getStringForKey:@"id"]];
    [self setTitle:[dictionary getStringForKey:@"title"]];
    [self setMessage:[dictionary getStringForKey:@"description"]];
    [self setLink:[dictionary getStringForKey:@"link"]];
    [self setDate:[NSDate dateWithTimeIntervalSince1970:[dictionary getDoubleForKey:@"created"]]];
    [self setReadValue:[dictionary getBoolForKey:@"read" defaultValue:@"NO"]];
    [self setTypeValue:[dictionary getIntegerForKey:@"type"]];
    [self setCategoryValue:[dictionary getIntegerForKey:@"category"]];
    [self setInnerIdValue:[dictionary getIntegerForKey:@"inner_id"]];    
}

- (BOOL)hasEqualId:(id)object
{
    if (isNull(object) || ![object isKindOfClass:[self class]])
    {
        return NO;
    }
    
    Notification *other = (Notification*)object;
    return [other.uid isEqualToString:self.uid];
}

@end

