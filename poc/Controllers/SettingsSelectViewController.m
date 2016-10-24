
#import <STPopup/STPopup.h>

#import "SettingsSelectViewController.h"

@interface SettingsSelectViewController ()

@end

@implementation SettingsSelectViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentSizeInPopup = CGSizeMake(300, 300);
    self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"cell"];

    NSString *item = self.items[indexPath.row];
    
    cell.textLabel.text = item;
    cell.accessoryType = [item isEqualToString:self.selectedItem] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItem = self.items[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(settingsSelectViewController:didSelect:)])
    {
        [self.delegate settingsSelectViewController:self didSelect:self.selectedItem];
    }
    [self.popupController popViewControllerAnimated:YES];
}

@end
