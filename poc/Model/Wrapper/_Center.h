// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Center.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CenterID : NSManagedObjectID {}
@end

@interface _Center : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CenterID *objectID;

@property (nonatomic, strong, nullable) NSString* address;

@property (nonatomic, strong, nullable) NSString* city;

@property (nonatomic, strong, nullable) NSNumber* distance;

@property (atomic) double distanceValue;
- (double)distanceValue;
- (void)setDistanceValue:(double)value_;

@property (nonatomic, strong, nullable) NSNumber* latitude;

@property (atomic) double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

@property (nonatomic, strong, nullable) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* province;

@property (nonatomic, strong, nullable) NSString* services0;

@property (nonatomic, strong, nullable) NSString* services1;

@property (nonatomic, strong, nullable) NSString* services2;

@property (nonatomic, strong, nullable) NSString* services3;

@property (nonatomic, strong, nullable) NSString* services4;

@property (nonatomic, strong, nullable) NSString* storeTimes;

@property (nonatomic, strong, nullable) NSString* type;

@property (nonatomic, strong, nullable) NSString* uid;

@end

@interface _Center (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(nullable NSString*)value;

- (nullable NSString*)primitiveCity;
- (void)setPrimitiveCity:(nullable NSString*)value;

- (nullable NSNumber*)primitiveDistance;
- (void)setPrimitiveDistance:(nullable NSNumber*)value;

- (double)primitiveDistanceValue;
- (void)setPrimitiveDistanceValue:(double)value_;

- (nullable NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(nullable NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;

- (nullable NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(nullable NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSString*)primitiveProvince;
- (void)setPrimitiveProvince:(nullable NSString*)value;

- (nullable NSString*)primitiveServices0;
- (void)setPrimitiveServices0:(nullable NSString*)value;

- (nullable NSString*)primitiveServices1;
- (void)setPrimitiveServices1:(nullable NSString*)value;

- (nullable NSString*)primitiveServices2;
- (void)setPrimitiveServices2:(nullable NSString*)value;

- (nullable NSString*)primitiveServices3;
- (void)setPrimitiveServices3:(nullable NSString*)value;

- (nullable NSString*)primitiveServices4;
- (void)setPrimitiveServices4:(nullable NSString*)value;

- (nullable NSString*)primitiveStoreTimes;
- (void)setPrimitiveStoreTimes:(nullable NSString*)value;

- (nullable NSString*)primitiveUid;
- (void)setPrimitiveUid:(nullable NSString*)value;

@end

@interface CenterAttributes: NSObject 
+ (NSString *)address;
+ (NSString *)city;
+ (NSString *)distance;
+ (NSString *)latitude;
+ (NSString *)longitude;
+ (NSString *)name;
+ (NSString *)province;
+ (NSString *)services0;
+ (NSString *)services1;
+ (NSString *)services2;
+ (NSString *)services3;
+ (NSString *)services4;
+ (NSString *)storeTimes;
+ (NSString *)type;
+ (NSString *)uid;
@end

NS_ASSUME_NONNULL_END
