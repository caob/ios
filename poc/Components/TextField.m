

#import "TextField.h"
#import "Constants.h"
#import "UIColor-Expanded.h"

@implementation TextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setTintColor:[UIColor colorWithRGBHex:kPrimaryDarkColor]];
}

@end
