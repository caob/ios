
#import <UIKit/UIKit.h>
#import "Center.h"

@interface CenterCell : UITableViewCell

@property (strong, nonatomic) Center *centerObj;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@end
