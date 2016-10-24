// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Notification.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NotificationID : NSManagedObjectID {}
@end

@interface _Notification : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) NotificationID *objectID;

@property (nonatomic, strong, nullable) NSNumber* category;

@property (atomic) int16_t categoryValue;
- (int16_t)categoryValue;
- (void)setCategoryValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSDate* date;

@property (nonatomic, strong, nullable) NSNumber* innerId;

@property (atomic) int16_t innerIdValue;
- (int16_t)innerIdValue;
- (void)setInnerIdValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString* link;

@property (nonatomic, strong, nullable) NSString* message;

@property (nonatomic, strong, nullable) NSNumber* read;

@property (atomic) BOOL readValue;
- (BOOL)readValue;
- (void)setReadValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString* title;

@property (nonatomic, strong, nullable) NSNumber* type;

@property (atomic) int16_t typeValue;
- (int16_t)typeValue;
- (void)setTypeValue:(int16_t)value_;

@property (nonatomic, strong) NSString* uid;

@end

@interface _Notification (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveCategory;
- (void)setPrimitiveCategory:(nullable NSNumber*)value;

- (int16_t)primitiveCategoryValue;
- (void)setPrimitiveCategoryValue:(int16_t)value_;

- (nullable NSDate*)primitiveDate;
- (void)setPrimitiveDate:(nullable NSDate*)value;

- (nullable NSNumber*)primitiveInnerId;
- (void)setPrimitiveInnerId:(nullable NSNumber*)value;

- (int16_t)primitiveInnerIdValue;
- (void)setPrimitiveInnerIdValue:(int16_t)value_;

- (nullable NSString*)primitiveLink;
- (void)setPrimitiveLink:(nullable NSString*)value;

- (nullable NSString*)primitiveMessage;
- (void)setPrimitiveMessage:(nullable NSString*)value;

- (nullable NSNumber*)primitiveRead;
- (void)setPrimitiveRead:(nullable NSNumber*)value;

- (BOOL)primitiveReadValue;
- (void)setPrimitiveReadValue:(BOOL)value_;

- (nullable NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(nullable NSString*)value;

- (NSString*)primitiveUid;
- (void)setPrimitiveUid:(NSString*)value;

@end

@interface NotificationAttributes: NSObject 
+ (NSString *)category;
+ (NSString *)date;
+ (NSString *)innerId;
+ (NSString *)link;
+ (NSString *)message;
+ (NSString *)read;
+ (NSString *)title;
+ (NSString *)type;
+ (NSString *)uid;
@end

NS_ASSUME_NONNULL_END
