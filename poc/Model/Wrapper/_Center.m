// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Center.m instead.

#import "_Center.h"

@implementation CenterID
@end

@implementation _Center

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Center" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Center";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Center" inManagedObjectContext:moc_];
}

- (CenterID*)objectID {
	return (CenterID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"distanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"distance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic address;

@dynamic city;

@dynamic distance;

- (double)distanceValue {
	NSNumber *result = [self distance];
	return [result doubleValue];
}

- (void)setDistanceValue:(double)value_ {
	[self setDistance:@(value_)];
}

- (double)primitiveDistanceValue {
	NSNumber *result = [self primitiveDistance];
	return [result doubleValue];
}

- (void)setPrimitiveDistanceValue:(double)value_ {
	[self setPrimitiveDistance:@(value_)];
}

@dynamic latitude;

- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:@(value_)];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:@(value_)];
}

@dynamic longitude;

- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:@(value_)];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:@(value_)];
}

@dynamic name;

@dynamic province;

@dynamic services0;

@dynamic services1;

@dynamic services2;

@dynamic services3;

@dynamic services4;

@dynamic storeTimes;

@dynamic type;

@dynamic uid;

@end

@implementation CenterAttributes 
+ (NSString *)address {
	return @"address";
}
+ (NSString *)city {
	return @"city";
}
+ (NSString *)distance {
	return @"distance";
}
+ (NSString *)latitude {
	return @"latitude";
}
+ (NSString *)longitude {
	return @"longitude";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)province {
	return @"province";
}
+ (NSString *)services0 {
	return @"services0";
}
+ (NSString *)services1 {
	return @"services1";
}
+ (NSString *)services2 {
	return @"services2";
}
+ (NSString *)services3 {
	return @"services3";
}
+ (NSString *)services4 {
	return @"services4";
}
+ (NSString *)storeTimes {
	return @"storeTimes";
}
+ (NSString *)type {
	return @"type";
}
+ (NSString *)uid {
	return @"uid";
}
@end

