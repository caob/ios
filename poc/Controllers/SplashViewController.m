
#import "SplashViewController.h"
#import "Constants.h"
#import "NSDictionary-Expanded.h"
#import "AppManager.h"
#import "DataManager.h"
#import "RequestManager.h"
#import "DrawerController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"Splash";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[DataManager sharedManager] prepopulateData];
    
//    [self verifySession];
    [self showNextView];
}

- (void)verifySession
{
    [[RequestManager sharedManager] GET:@"/verify.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        [self showNextView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
        
        [self showNextView];
    }];
}

- (void)showNextView
{
    if ([AppManager sharedManager].loggedIn)
    {
        DrawerController *drawerController = [self.storyboard instantiateViewControllerWithIdentifier:@"DrawerController"];
        
//TODO: process incoming notification
//        NSDictionary *data = @{
//                               @"id": @(4),
//                               @"type": @(kNotificationTypeMessage),
//                               @"category": @(1),
//                               @"title": @"type 2 cate 1 profile",
//                               @"description": @"description",
//                               @"innerId": @(kNotificationInnerIdInbox),
//                               @"read": @(NO),
//                               @"date": @(1477075066)
//                               };
//        if (!isEmpty(data))
//        {
//            drawerController.initialNotification = [[DataManager sharedManager] getOrCreateNotificationWithDictionary:data error:nil];
//        }
        [self.navigationController setViewControllers:@[drawerController] animated:NO];
    }
    else
    {
        [self.navigationController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"]] animated:YES];
    }
}

@end
