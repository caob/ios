
#import <MMDrawerController/MMDrawerController.h>

#import "Notification.h"

@interface DrawerController : MMDrawerController

@property (nonatomic, strong, readonly) UINavigationController *mainNavigationController;
@property (nonatomic, assign) Notification *initialNotification;

- (void)showHome;
- (void)showInbox;
- (void)showCenters;
- (void)showProfile;
- (void)showAbout;
- (void)showInnerId:(kNotificationInnerId)innerId;

@end

@interface UIViewController (DrawerController)

@property(nonatomic, strong, readonly) DrawerController *drawerController;

@end
