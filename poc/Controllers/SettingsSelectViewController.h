
#import <UIKit/UIKit.h>

@class SettingsSelectViewController;

@protocol SettingsSelectViewControllerDelegate <NSObject>

- (void)settingsSelectViewController:(SettingsSelectViewController *)viewController didSelect:(NSString*)selection;

@end

@interface SettingsSelectViewController : UITableViewController

@property (nonatomic, weak) id<SettingsSelectViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *selectionType;
@property (nonatomic, strong) NSString *selectedItem;

@end
