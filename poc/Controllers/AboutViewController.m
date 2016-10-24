

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Acerca de...";
    self.screenName = @"Acerca de...";
}

- (IBAction)onCallPressend:(id)sender
{
    NSURL *phoneUrl = [NSURL URLWithString:@"tel:*111"];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
    {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"No disponible en este dispositivo" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ACEPTAR" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
