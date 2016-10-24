
#import <STPopup/STPopup.h>

#import "SettingsViewController.h"
#import "SettingsSelectViewController.h"

@interface SettingsViewController () <SettingsSelectViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *orderCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *categoryCell;

@end

@implementation SettingsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.title = @"Filtros";
    
    self.contentSizeInPopup = CGSizeMake(250, 200);
    self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Aplicar" style:UIBarButtonItemStylePlain target:self action:@selector(onDonePressed:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateCells];
}

- (void)onDonePressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(settingsViewController:didApplySettings:)])
    {
        [self.delegate settingsViewController:self didApplySettings:self.settings];
    }    
    [self.popupController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SettingsSelectViewController *destinationViewController = (SettingsSelectViewController *)segue.destinationViewController;
    destinationViewController.delegate = self;
    if ([segue.identifier isEqualToString:kFilterTypeOrder])
    {
        destinationViewController.selectionType = kFilterTypeOrder;
        destinationViewController.title = @"Ordenar por";
        destinationViewController.items = @[@"fecha", @"titulo", @"no leidos"];
        destinationViewController.selectedItem = [self.settings objectForKey:kFilterTypeOrder];
    }
    else if ([segue.identifier isEqualToString:kFilterTypeCategory])
    {
        destinationViewController.selectionType = kFilterTypeCategory;
        destinationViewController.title = @"Categoria";
        destinationViewController.items = @[@"todas", @"info de la app", @"promociones", @"noticias"];
        destinationViewController.selectedItem = [self.settings objectForKey:kFilterTypeCategory];
    }
}

- (void)updateCells
{
    self.categoryCell.detailTextLabel.text = [self.settings objectForKey:kFilterTypeCategory];
    self.orderCell.detailTextLabel.text = [self.settings objectForKey:kFilterTypeOrder];
}

#pragma mark SettingsSelectViewControllerDelegate

- (void)settingsSelectViewController:(SettingsSelectViewController *)viewController didSelect:(NSString*)selection
{
    if ([kFilterTypeOrder isEqualToString:viewController.selectionType])
    {
        [self.settings setObject:selection forKey:kFilterTypeOrder];
    }
    else if ([kFilterTypeCategory isEqualToString:viewController.selectionType])
    {
        [self.settings setObject:selection forKey:kFilterTypeCategory];
    }
    
    [self updateCells];
}

@end
