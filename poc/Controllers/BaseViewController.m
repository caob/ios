

#import <MMDrawerController/MMDrawerBarButtonItem.h>

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController.viewControllers count] == 1)
    {
        [self setupLeftMenuButton];
    }
}

- (void)setupLeftMenuButton
{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress
{
    [self.view endEditing:YES];
    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
