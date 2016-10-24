
#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewController:(SettingsViewController *)viewController didApplySettings:(NSDictionary*)settings;

@end

#define kFilterTypeOrder        @"order"
#define kFilterTypeCategory     @"category"

@interface SettingsViewController : UITableViewController

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *settings;

@end
