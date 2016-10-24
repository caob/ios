

#import "CenterCell.h"
#import "Constants.h"

@interface CenterCell ()

@end


@implementation CenterCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.iconImageView.image = [self.iconImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.categoryLabel setTextColor:[UIColor colorWithRGBHex:kGrayTextColor]];
    [self.distanceLabel setTextColor:[UIColor colorWithRGBHex:kGrayTextColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCenterObj:(Center *)centerObj
{
    _centerObj = centerObj;
    [self.titleLabel setText:centerObj.name];
    [self.categoryLabel setText:centerObj.type];
    [self.iconImageView setTintColor:centerObj.color];

    if (centerObj.distanceValue < 1000)
    {
        [self.distanceLabel setText:[NSString stringWithFormat:@"%.0f m", centerObj.distanceValue]];
    }
    else if (centerObj.distanceValue > 0.01)
    {
        [self.distanceLabel setText:[NSString stringWithFormat:@"%.2f km", centerObj.distanceValue/1000]];
    }
    else
    {
        [self.distanceLabel setText:@""];
    }
}

@end
