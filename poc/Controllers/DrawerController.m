
#import <MMDrawerController/MMDrawerBarButtonItem.h>
#import "DrawerController.h"
#import "MessageViewController.h"
#import "LinkViewController.h"

@interface DrawerController ()

@end

@implementation DrawerController

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setLeftDrawerViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"]];

    _mainNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    [self setCenterViewController:_mainNavigationController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self processNotification:self.initialNotification];
    self.initialNotification = nil;
}

- (void)processNotification:(Notification*)notification
{
    if(notification)
    {
       if (notification.typeValue == kNotificationTypeInnerId)
       {
           [self showInnerId:notification.innerIdValue];
       }
       else
       {
           UIViewController *viewController;
           if (notification.typeValue == kNotificationTypeMessage)
           {
               viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
               [(MessageViewController*)viewController setNotification:notification];
           }
           else if (notification.typeValue == kNotificationTypeLink)
           {
               viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LinkViewController"];
               [(LinkViewController*)viewController setNotification:notification];
           }
           
           [self closeDrawerAnimated:YES completion:nil];
           [self.mainNavigationController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"InboxViewController"], viewController] animated:NO];
       }
    }
}

#pragma mark navigation

- (void)setViewControllerWithIdentifier:(NSString*)identifier
{
    [self setViewControllerWithIdentifier:identifier animated:NO];
}

- (void)setViewControllerWithIdentifier:(NSString*)identifier animated:(BOOL)animated
{
    [self closeDrawerAnimated:YES completion:nil];
    [self.mainNavigationController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:identifier]] animated:animated];
}

- (void)showInnerId:(kNotificationInnerId)innerId
{   
    if (innerId == kNotificationInnerIdCenters)
    {
        [self showCenters];
    }
    else if (innerId == kNotificationInnerIdAbout)
    {
        [self showAbout];
    }
    else if (innerId == kNotificationInnerIdInbox)
    {
        [self showInbox];
    }
    else if (innerId == kNotificationInnerIdProfile)
    {
        [self showProfile];
    }
}

- (void)showHome
{
    [self setViewControllerWithIdentifier:@"HomeViewController"];
}

- (void)showInbox
{
    [self setViewControllerWithIdentifier:@"InboxViewController"];
}

- (void)showCenters
{
    [self setViewControllerWithIdentifier:@"CenterViewController"];
}

- (void)showProfile
{
    [self closeDrawerAnimated:YES completion:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"]];
    [self presentViewController:navigationController animated:YES completion:nil];
//    [self setViewControllerWithIdentifier:@"ProfileViewController"];
}

- (void)showAbout
{
    [self setViewControllerWithIdentifier:@"AboutViewController"];
}

@end

@implementation UIViewController (DrawerController)

- (DrawerController*)drawerController
{
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController != nil)
    {
        if([parentViewController isKindOfClass:[DrawerController class]])
        {
            return (DrawerController*)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}
@end
