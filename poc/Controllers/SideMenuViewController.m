
#import "SideMenuViewController.h"
#import "DrawerController.h"
#import "AppManager.h"
#import "DataManager.h"
#import "Constants.h"

@interface SideMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) NSArray *menuIcons;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;

@end

@implementation SideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.profileLabel setTextColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    User *user = [AppManager sharedManager].currentUser;

    self.profileLabel.text = user.fullName;
}

#pragma mark table view

- (NSArray*)menuItems
{
    if (!_menuItems)
    {
        return @[@"HOME", @"INBOX", @"CENTROS DE ATENCIÓN", @"ACERCA DE...", @"+ APPS", @"LOGOUT"];
    }
    return _menuItems;
}

- (NSArray*)menuIcons
{
    if (!_menuIcons)
    {
        return @[@"ico-home", @"ico-email", @"ico-pointer-line", @"ico-info", @"ico-bug", @"ico-logout"];
    }
    return _menuIcons;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label = [cell.contentView viewWithTag:1];
    UIImageView *image = [cell.contentView viewWithTag:2];
    
    [label setText:self.menuItems[indexPath.row]];
    [label setTextColor:[UIColor colorWithRGBHex:kGrayTextColor]];
    [image setImage:[UIImage imageNamed:self.menuIcons[indexPath.row]]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        [self.drawerController showHome];
    }
    else if (indexPath.row == 1)
    {
        [self.drawerController showInbox];
    }
    else if (indexPath.row == 2)
    {
        [self.drawerController showCenters];
    }
    else if (indexPath.row == 3)
    {
        [self.drawerController showAbout];
    }
    else if (indexPath.row == 4)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/telecompersonal"]];
    }
    else if (indexPath.row == 5)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"¿Esta seguro que desea salir?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"SI" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [[AppManager sharedManager] setLoggedIn:NO];
            [[DataManager sharedManager] deleteAllNotifications];
            [self.drawerController.navigationController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"SplashViewController"]] animated:YES];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self.drawerController closeDrawerAnimated:YES completion:nil];        
    }
}

- (IBAction)onProfileImageTapped:(id)sender
{
    [self.drawerController showProfile];
}

- (IBAction)onProfileTapped:(id)sender
{
    [self.drawerController showProfile];
}

@end
