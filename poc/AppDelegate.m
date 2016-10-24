
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import <GoogleAnalytics/GAI.h>

#import "AppDelegate.h"
#import "Constants.h"
#import "AppManager.h"
#import "DataManager.h"
#import "NSDictionary-Expanded.h"


@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif

#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    if (CACHE_ENABLED)
    {
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10*1024*1024 diskCapacity:500*1024*1024 diskPath:@"app_cache"];
        [NSURLCache setSharedURLCache:cache];
        sleep(0.1);
    }   
    
    GAI *gai = [GAI sharedInstance];
    [gai trackerWithTrackingId:GAI_TRACKING_ID];
    gai.trackUncaughtExceptions = NO;
    gai.dryRun = DEBUG_BOOL;
    if (GAI_DEBUG_ENABLED)
    {
        gai.logger.logLevel = kGAILogLevelVerbose;        
    }

    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max)
    {
        UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {}];
        
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
        [[FIRMessaging messaging] setRemoteMessageDelegate:self];
#endif
    }
    
    [FIRApp configure];
    
    [Fabric with:@[[Digits class]]];
    
    [[AppManager sharedManager] initialize];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self connectToFcm];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[DataManager sharedManager] saveContext];
}

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSString *newToken = [deviceToken description];
//    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    [defaults setObject:newToken forKey:@"deviceToken"];
//    [defaults synchronize];
//    
//    [[AppManager sharedManager] registerDevice];
//}
//
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//{
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    [[AppManager sharedManager] processNotification:userInfo];
//}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    NSLog(@"%@", userInfo);
    NSDictionary *aps = userInfo[@"aps"];
    NSString *alert = [aps getStringForKey:@"alert"];

    if(application.applicationState == UIApplicationStateInactive)
    {
    }
    else if (application.applicationState == UIApplicationStateBackground) {
        
        NSLog(@"application Background - notification has arrived when app was in background");
        NSString* contentAvailable = [NSString stringWithFormat:@"%@", [[userInfo valueForKey:@"aps"] valueForKey:@"content-available"]];
        if([contentAvailable isEqualToString:@"1"])
        {
            completionHandler(UIBackgroundFetchResultNewData);
        }
    }
    else
    {
    }
}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    NSLog(@"%@", userInfo);
}

- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage
{
    NSLog(@"%@", [remoteMessage appData]);
}
#endif

- (void)tokenRefreshNotification:(NSNotification *)notification
{
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    [[FIRMessaging messaging] subscribeToTopic:@"topics/IOS"];
    [[FIRMessaging messaging] subscribeToTopic:@"topics/INFAPP"];
    [[FIRMessaging messaging] subscribeToTopic:@"topics/PROMOS"];
    [[FIRMessaging messaging] subscribeToTopic:@"topics/NOTICIA"];

    
    [self connectToFcm];
}

- (void)connectToFcm
{
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error)
    {
        if (error != nil)
        {
            NSLog(@"Unable to connect to FCM. %@", error);
        }
        else
        {
            NSLog(@"Connected to FCM.");
        }
    }];
}

@end
