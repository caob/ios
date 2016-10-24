// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Notification.m instead.

#import "_Notification.h"

@implementation NotificationID
@end

@implementation _Notification

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Notification";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:moc_];
}

- (NotificationID*)objectID {
	return (NotificationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"categoryValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"category"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"innerIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"innerId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"readValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"read"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic category;

- (int16_t)categoryValue {
	NSNumber *result = [self category];
	return [result shortValue];
}

- (void)setCategoryValue:(int16_t)value_ {
	[self setCategory:@(value_)];
}

- (int16_t)primitiveCategoryValue {
	NSNumber *result = [self primitiveCategory];
	return [result shortValue];
}

- (void)setPrimitiveCategoryValue:(int16_t)value_ {
	[self setPrimitiveCategory:@(value_)];
}

@dynamic date;

@dynamic innerId;

- (int16_t)innerIdValue {
	NSNumber *result = [self innerId];
	return [result shortValue];
}

- (void)setInnerIdValue:(int16_t)value_ {
	[self setInnerId:@(value_)];
}

- (int16_t)primitiveInnerIdValue {
	NSNumber *result = [self primitiveInnerId];
	return [result shortValue];
}

- (void)setPrimitiveInnerIdValue:(int16_t)value_ {
	[self setPrimitiveInnerId:@(value_)];
}

@dynamic link;

@dynamic message;

@dynamic read;

- (BOOL)readValue {
	NSNumber *result = [self read];
	return [result boolValue];
}

- (void)setReadValue:(BOOL)value_ {
	[self setRead:@(value_)];
}

- (BOOL)primitiveReadValue {
	NSNumber *result = [self primitiveRead];
	return [result boolValue];
}

- (void)setPrimitiveReadValue:(BOOL)value_ {
	[self setPrimitiveRead:@(value_)];
}

@dynamic title;

@dynamic type;

- (int16_t)typeValue {
	NSNumber *result = [self type];
	return [result shortValue];
}

- (void)setTypeValue:(int16_t)value_ {
	[self setType:@(value_)];
}

@dynamic uid;

@end

@implementation NotificationAttributes 
+ (NSString *)category {
	return @"category";
}
+ (NSString *)date {
	return @"date";
}
+ (NSString *)innerId {
	return @"innerId";
}
+ (NSString *)link {
	return @"link";
}
+ (NSString *)message {
	return @"message";
}
+ (NSString *)read {
	return @"read";
}
+ (NSString *)title {
	return @"title";
}
+ (NSString *)type {
	return @"type";
}
+ (NSString *)uid {
	return @"uid";
}
@end

