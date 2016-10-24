
#import <MapKit/MapKit.h>
#import <INTULocationManager/INTULocationManager.h>

#import "CenterViewController.h"
#import "CenterDetailViewController.h"
#import "Constants.h"
#import "NSDictionary-Expanded.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "CenterCell.h"

@interface CenterViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation CenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Centros de Atención";
    self.screenName = @"Centros de Atención";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Center"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES],]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[DataManager sharedManager].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:10.0 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        //TODO: handle unknown location
        [self centerMapOnCoordinate:currentLocation.coordinate animated:NO];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Center entityName]];
        request.returnsObjectsAsFaults = NO;
        
        NSError *error = nil;
        NSArray *data = [[DataManager sharedManager].managedObjectContext executeFetchRequest:request error:&error];
        [data enumerateObjectsUsingBlock:^(Center *center, NSUInteger idx, BOOL * _Nonnull stop) {
            [center updateDistanceWithLocation:currentLocation];
        }];
        [[DataManager sharedManager] saveContext];
        
        [self loadData];
    }];
}

- (void)centerMapOnCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated
{
    MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000);
    [self.mapView setRegion:mapRegion animated:animated];
}

#pragma mark data

//TODO: sync centers with server
//- (void)syncCenters
//{
//    [self.refreshControl beginRefreshing];
//    [[RequestManager sharedManager] GET:@"/getCentros" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        id userLocation = [self.mapView userLocation];
//        NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
//        if (userLocation != nil)
//        {
//            [pins removeObject:userLocation];
//        }
//        [self.mapView removeAnnotations:pins];
//
//        self.data = [NSMutableArray array];
//        [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            Center *center = [[Center alloc] initWithDictionary:obj];
//            [self.data addObject:center];
//            [self.mapView addAnnotation:center.annotation];
//            
//        }];
//        
//        [self.tableView reloadData];
//        [self.refreshControl endRefreshing];
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//       
//        NSLog(@"%@", [error localizedDescription]);
//        [self.refreshControl endRefreshing];
//
//    }];
//}

- (void)loadData
{
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint neMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), mRect.origin.y);
    MKMapPoint swMapPoint = MKMapPointMake(mRect.origin.x, MKMapRectGetMaxY(mRect));
    CLLocationCoordinate2D neCoord = MKCoordinateForMapPoint(neMapPoint);
    CLLocationCoordinate2D swCoord = MKCoordinateForMapPoint(swMapPoint);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"latitude > %f && longitude > %f && latitude < %f && longitude < %f", swCoord.latitude, swCoord.longitude, neCoord.latitude, neCoord.longitude];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self.fetchedResultsController.fetchRequest setFetchBatchSize:200];
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    
    [self configureAnnotations];
}

- (void)configureAnnotations
{
    id userLocation = [self.mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if (userLocation != nil)
    {
        [pins removeObject:userLocation];
    }
    [self.mapView removeAnnotations:pins];
    [[self.fetchedResultsController fetchedObjects] enumerateObjectsUsingBlock:^(Center *center, NSUInteger idx, BOOL * _Nonnull stop) {        
        [self.mapView addAnnotation:center.annotation];
        if (idx >= 200)
        {
            *stop = YES;
        }
    }];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(Center*)center atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [self.mapView addAnnotation:center.annotation];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [self.mapView removeAnnotation:center.annotation];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    Center *center = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [(CenterCell*)cell setCenterObj:center];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Center *center = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CenterDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CenterDetailViewController"];
    [viewController setCenter:center];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self loadData];    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    static NSString *identifier = @"annotation";
    
    UIImageView *imageView;
    MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;

        UIImage *image = [[UIImage imageNamed:@"ico-pointer"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setTag:10];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setTransform:CGAffineTransformMakeScale(0.5, 0.5)];
        
        [annotationView addSubview:imageView];        
    }
    else
    {
        annotationView.annotation = annotation;
        imageView = [annotationView viewWithTag:10];
    }
    
    [imageView setTintColor:((CenterAnnotation*)annotation).center.color];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Center *center = ((CenterAnnotation*)view.annotation).center;
    CenterDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CenterDetailViewController"];
    [viewController setCenter:center];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
