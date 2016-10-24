
#import <QuartzCore/QuartzCore.h>

#import "GradientView.h"
#import "Constants.h"
#import "UIColor-Expanded.h"


@interface GradientView ()

@property (nonatomic, strong, readonly) CAGradientLayer *layer;

@end

@implementation GradientView
@dynamic layer;

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    UIColor *color1 = [UIColor colorWithRGBHex:kPrimaryColor];
    UIColor *color2 = [UIColor colorWithRGBHex:kPrimaryDarkColor];
    
    self.layer.colors = [NSArray arrayWithObjects:(id)color1.CGColor, (id)color2.CGColor, nil];
    self.layer.startPoint = CGPointZero;
    self.layer.endPoint = CGPointMake(1, 1);
}
@end
