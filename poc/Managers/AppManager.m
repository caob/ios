
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>

#import "AppManager.h"
#import "Constants.h"
#import "NSDictionary-Expanded.h"
#import "UIColor-Expanded.h"

@implementation AppManager

+ (AppManager*)sharedManager
{
    static AppManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[AppManager alloc] init];
    });
    return _sharedManager;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedStatusChanged:) name:@"LoggedStatusChanged" object:nil];
    }
    return self;
}

- (void)initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{
                                 @"loggedIn": @(NO),
                                 }];
    [defaults synchronize];
    
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRGBHex:kPrimaryDarkColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRGBHex:kDarkTextColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:kDarkTextColor]}];
    [[UILabel appearance] setTextColor:[UIColor colorWithRGBHex:kDarkTextColor]];
}

#pragma mark properties

- (void)setCurrentUser:(User *)currentUser
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:currentUser] forKey:@"currentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (User *)currentUser
{
    @try
    {
        return (User *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"]];
    }
    @catch (NSException *exception)
    {
        return nil;
    }
}

- (void)setLoggedIn:(BOOL)loggedIn
{
    if (self.loggedIn && !loggedIn)
    {
//        [[Digits sharedInstance] logOut];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:loggedIn forKey:@"loggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)loggedIn
{
    if (FORCE_VALID_SESSION)
    {
        return YES;
    }
    else
    {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    }    
}

#pragma mark methods

- (void)registerDevice
{
#if !TARGET_IPHONE_SIMULATOR
    NSString *deviceUuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    if(!deviceToken)
    {
        return;
    }
    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];
//    [params setObject:deviceToken forKey:@"registration_id"];
//    [params setObject:deviceUuid forKey:@"device_id"];
//    
//    [[RequestManager sharedManager] POST:@"devices/iphone/register/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"%@", responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
//    }];
#endif
}

#pragma mark notifications

- (void)processNotification:(NSDictionary*)notification
{
//    NSDictionary *aps = notification[@"aps"];
//    NSString *alert = [aps getStringForKey:@"alert"];
//    NSInteger badge = [aps getIntegerForKey:@"badge"];
}

- (void)loggedStatusChanged:(NSNotification*)notification
{
    [self performBlock:^{
        [self registerDevice];
    } afterDelay:0.1];
}

@end
