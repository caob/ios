
#import <STPopup/STPopup.h>

#import "InboxViewController.h"
#import "Constants.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "NotificationCell.h"
#import "MessageViewController.h"
#import "LinkViewController.h"
#import "SettingsViewController.h"

@interface InboxViewController ()  <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, SettingsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableDictionary *settings;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@end

@implementation InboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Inbox";
    self.screenName = @"Inbox";

    [self.filterButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.settings = [NSMutableDictionary dictionary];
    [self.settings setObject:@"fecha" forKey:kFilterTypeOrder];
    [self.settings setObject:@"todas" forKey:kFilterTypeCategory];

    
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingsIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsPressed:)];
//    [self.navigationItem setRightBarButtonItem:barButton];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(syncNotifications) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self loadData];
    [self syncNotifications];
}

#pragma mark actions

- (IBAction)onSettingsPressed:(id)sender
{
    SettingsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    viewController.settings = self.settings;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:viewController];
    [popupController presentInViewController:self];
}

- (IBAction)onProfilePressed:(id)sender
{
    [self.drawerController showProfile];
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)syncNotifications
{
    
    [[RequestManager sharedManager] GET:@"http://beta.json-generator.com/api/json/get/Vki5ux8kG" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//    [[RequestManager sharedManager] GET:@"/api/notificaciones/timestamp/gte?timestamp=1477249252097" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        DataManager *dataManager = [DataManager sharedManager];
        [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dataManager getOrCreateNotificationWithDictionary:obj error:nil];
        }];
        [dataManager saveContext];

        [self.refreshControl endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
        
        [self.refreshControl endRefreshing];
    }];
}

- (void)loadData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Notification"];
   
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO],]];
//    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES selector:@selector(caseInsensitiveCompare:)],]];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event.uid==%@", [ApplicationManager sharedManager].eventId];
    //[fetchRequest setPredicate:predicate];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[DataManager sharedManager].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    [self.fetchedResultsController performFetch:nil];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type)
    {
            case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
            case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
            case NSFetchedResultsChangeUpdate:
        {
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
            case NSFetchedResultsChangeMove:
        {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [(NotificationCell*)cell setNotification:notification];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (notification.typeValue == kNotificationTypeMessage)
    {
        MessageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
        [viewController setNotification:notification];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (notification.typeValue == kNotificationTypeLink)
    {
        LinkViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LinkViewController"];
        [viewController setNotification:notification];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (notification.typeValue == kNotificationTypeInnerId)
    {
        [self.drawerController showInnerId:notification.innerIdValue];
    }
}

#pragma mark SettingsViewControllerDelegate

- (void)settingsViewController:(SettingsViewController *)viewController didApplySettings:(NSDictionary*)settings
{
    self.settings = [settings mutableCopy];
    [self loadData];
}

@end
