
#import <Foundation/Foundation.h>
#import "User.h"

@interface AppManager : NSObject

@property (assign, nonatomic) BOOL loggedIn;
@property (strong, nonatomic) User *currentUser;

+ (AppManager*)sharedManager;

- (void)initialize;
- (void)registerDevice;
- (void)processNotification:(NSDictionary*)notification;

@end
