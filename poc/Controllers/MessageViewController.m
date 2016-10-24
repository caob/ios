
#import "MessageViewController.h"

@interface MessageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.screenName = self.notification.title;
 
    [self.titleLabel setText:self.notification.title];
    [self.messageLabel setText:self.notification.message];
}


@end
