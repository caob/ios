#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

#import "_Center.h"

@class CenterAnnotation;
@interface Center : _Center

@property (strong, nonatomic, readonly) CLLocation *location;
@property (strong, nonatomic, readonly) CenterAnnotation *annotation;
@property (nonatomic, readonly) UIColor *color;

- (instancetype)initWithArray:(NSArray*)array;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

- (void)loadFromDictionary:(NSDictionary*)dictionary;
- (void)loadFromArray:(NSArray*)array;

- (void)updateDistanceWithLocation:(CLLocation*)location;

@end

@interface CenterAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;

@property (strong, nonatomic, nullable) Center *center;


@end
