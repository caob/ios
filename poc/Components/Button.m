
#import <QuartzCore/QuartzCore.h>

#import "Button.h"
#import "Constants.h"
#import "UIColor-Expanded.h"

@implementation Button

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{    
    self.layer.cornerRadius = kDefaultButtonCornerRadius;
    
    [self setTitleColor:[UIColor colorWithRGBHex:kDefaultButtonTintColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRGBHex:kDefaultButtonTintHighlightedColor] forState:UIControlStateHighlighted];
    
    [self setLoadingButtonAlignment:CNLLoadingButtonAlignmentLeft];
    [self setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    
    [self setHighlighted:NO];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    [super setHighlighted:highlighted];
    
    if (highlighted)
    {
        self.layer.backgroundColor = [UIColor colorWithRGBHex:kDefaultButtonHighlightedColor].CGColor;
    }
    else
    {
        self.layer.backgroundColor = [UIColor colorWithRGBHex:kDefaultButtonColor].CGColor;
    }

    [CATransaction commit];
}

@end
