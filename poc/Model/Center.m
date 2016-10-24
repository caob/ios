
#import "Center.h"
#import "NSDictionary-Expanded.h"
#import "Constants.h"

@interface Center ()
{
    CenterAnnotation *_annotation;
    CLLocation *_location;
}

@end

@implementation Center

- (instancetype)initWithArray:(NSArray*)array
{
    self = [super init];
    if (self)
    {
        [self loadFromArray:array];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        [self loadFromDictionary:dictionary];
    }
    return self;
}

- (void)loadFromDictionary:(NSDictionary*)dictionary
{
}

- (void)loadFromArray:(NSArray*)array
{
    self.uid = array[0];
    self.type = array[1];
    self.name = array[2];
    self.address = array[3];
    self.city = array[4];
    self.services0 = array[6];
    self.services1 = array[7];
    self.services2 = array[8];
    self.services3 = array[9];
    self.services4 = array[10];
    self.latitude = @([array[11] doubleValue]);
    self.longitude = @([array[12] doubleValue]);
    self.storeTimes = array[13];
}

- (BOOL)hasEqualId:(id)object
{
    if (isNull(object) || ![object isKindOfClass:[self class]])
    {
        return NO;
    }
    
    Center *other = (Center*)object;
    return [other.uid isEqualToString:self.uid];
}

- (CenterAnnotation*)annotation
{
    if (!_annotation)
    {
        _annotation = [CenterAnnotation new];
        [_annotation setCenter:self];
        [_annotation setCoordinate:CLLocationCoordinate2DMake(self.latitudeValue, self.longitudeValue)];
    }
    
    return _annotation;
}

- (CLLocation*)location
{
    if (!_location)
    {
        _location = [[CLLocation alloc] initWithLatitude:self.latitudeValue longitude:self.longitudeValue];
    }
    return _location;
}

- (void)updateDistanceWithLocation:(CLLocation*)location
{
    [self willChangeValueForKey:@"distance"];
    [self setDistanceValue:[self.location distanceFromLocation:location]];
    [self didChangeValueForKey:@"distance"];
}

- (UIColor*)color
{
    if ([[self.type lowercaseString] isEqualToString:@"retail"])
    {
        return [UIColor colorWithRGBHex:kAppInfoColor];
    }
    else if ([[self.type lowercaseString] isEqualToString:@"agente ocicial"])
    {
        return [UIColor colorWithRGBHex:kPromotionsColor];
    }
    else
    {
        return [UIColor colorWithRGBHex:kNewsColor];
    }
}

@end

@implementation CenterAnnotation

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

- (NSString*)title
{
    return self.center.type;
}

- (NSString*)subtitle
{
    return self.center.name;
}

@end
