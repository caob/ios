
#import "NotificationCell.h"
#import "Constants.h"

@interface NotificationCell ()

@end

@implementation NotificationCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dotImageView.image = [self.dotImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.categoryLabel setTextColor:[UIColor colorWithRGBHex:kGrayTextColor]];
    [self.dateLabel setTextColor:[UIColor colorWithRGBHex:kGrayTextColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setNotification:(Notification *)notification
{
    _notification = notification;
    [self.titleLabel setText:notification.title];
    if (notification.categoryValue == kNotificationCategoryInfo)
    {
        [self.dotImageView setTintColor:[UIColor colorWithRGBHex:kAppInfoColor]];
        [self.categoryLabel setText:@"Información de Apps"];
    }
    else if (notification.categoryValue == kNotificationCategoryNews)
    {
        [self.dotImageView setTintColor:[UIColor colorWithRGBHex:kNewsColor]];
        [self.categoryLabel setText:@"Noticias"];
    }
    else
    {
        [self.dotImageView setTintColor:[UIColor colorWithRGBHex:kPromotionsColor]];
        [self.categoryLabel setText:@"Promociones"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd'/'MM'/'yyyy"];
    
    if (notification.date)
    {
        [self.dateLabel setText:[dateFormatter stringFromDate:notification.date]];
    }
    else
    {
        [self.dateLabel setText:@""];
    }
}

@end
