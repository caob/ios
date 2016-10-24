
#import <MapKit/MapKit.h>

#import "CenterDetailViewController.h"
#import "Center.h"
#import "Constants.h"

@interface CenterDetailViewController () <MKMapViewDelegate> 

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@end

@implementation CenterDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.screenName = [NSString stringWithFormat:@"%@ - %@", self.center.name, self.center.type];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ - %@", self.center.name, self.center.type];
    self.detailsLabel.text = [NSString stringWithFormat:@"%@\n%@", self.center.address, self.center.storeTimes];
    
    [self.mapView addAnnotation:self.center.annotation];
   
    MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(self.center.annotation.coordinate, 1000, 1000);
    [self.mapView setRegion:mapRegion animated:YES];
}

@end
