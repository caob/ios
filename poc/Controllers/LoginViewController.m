

#import <DigitsKit/DigitsKit.h>

#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "Constants.h"
#import "UIColor-Expanded.h"
#import "AppManager.h"
#import "RequestManager.h"
#import "User.h"
#import "Button.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet Button *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.screenName = @"Login";
}

#pragma mark actions

- (IBAction)loginPressed:(id)sender
{
    Digits *digits = [Digits sharedInstance];
    
    DGTAuthenticationConfiguration *configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsDefaultOptionMask];
    configuration.phoneNumber = @"+54";
    configuration.title = @"";
    configuration.appearance = [[DGTAppearance alloc] init];
    configuration.appearance.accentColor = [UIColor colorWithRGBHex:kPrimaryDarkColor];
    configuration.appearance.logoImage = [UIImage imageNamed:@"wideLogo"];
    
    [self.loginButton startLoading];
    [digits authenticateWithViewController:nil configuration:configuration completion:^(DGTSession *session, NSError *error){
        
        if (session.userID)
        {
            [self authenticate];
        }
        else if (error)
        {
            NSLog(@"Authentication error: %@", error.localizedDescription);
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ACEPTAR" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        [self.loginButton endLoading];
    }];
}

- (void)authenticate
{
    Digits *digits = [Digits sharedInstance];
    
    DGTOAuthSigning *oauthSigning = [[DGTOAuthSigning alloc] initWithAuthConfig:digits.authConfig authSession:digits.session];
    NSDictionary *authHeaders = [oauthSigning OAuthEchoHeadersToVerifyCredentials];

    NSLog(@"%@", authHeaders);
    
    [[RequestManager sharedManager] POST:@"/api/auth" parameters:authHeaders progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        [self.loginButton endLoading];
        
        User *user = [[User alloc] initWithDictionary:responseObject];
        [[AppManager sharedManager] setCurrentUser:user];
        [[AppManager sharedManager] setLoggedIn:YES];
        
        ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        viewController.isInitialProfile = YES;
        [self.navigationController setViewControllers:@[viewController] animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
        [self.loginButton endLoading];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ACEPTAR" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];        
    }];
}

@end
