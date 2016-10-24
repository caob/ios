
#import <UIKit/UIKit.h>
#import "Notification.h"

@interface NotificationCell : UITableViewCell

@property (strong, nonatomic) Notification *notification;
@property (weak, nonatomic) IBOutlet UIImageView *dotImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
