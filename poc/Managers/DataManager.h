

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Notification.h"
#import "Center.h"

@interface DataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSURL *storeUrl;

+ (DataManager*)sharedManager;

- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)persistentStoreCoordinator;
- (void)saveContext;

- (void)prepopulateData;

- (Notification*)getNotificationWithPredicate:(NSPredicate*)predicate create:(BOOL)create error:(NSError **)error;
- (Notification*)getNotificationWithId:(NSString*)uid error:(NSError **)error;
- (Notification*)getOrCreateNotificationWithId:(NSString*)uid error:(NSError **)error;
- (Notification*)getOrCreateNotificationWithDictionary:(NSDictionary*)dictionary error:(NSError **)error;
- (void)deleteAllNotifications;

- (Center*)getCenterWithPredicate:(NSPredicate*)predicate create:(BOOL)create error:(NSError **)error;
- (Center*)getCenterWithId:(NSString*)uid error:(NSError **)error;
- (Center*)getOrCreateCenterWithId:(NSString*)uid error:(NSError **)error;
- (Center*)getOrCreateCenterWithDictionary:(NSDictionary*)dictionary error:(NSError **)error;
- (Center*)getOrCreateCenterWithArray:(NSArray*)array error:(NSError **)error;

- (void)debugLogEntityWithName:(NSString*)name;

@end
