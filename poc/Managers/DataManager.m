
#import <CHCSVParser/CHCSVParser.h>

#import "DataManager.h"
#import "Constants.h"
#import "NSDictionary-Expanded.h"

@implementation DataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (DataManager*)sharedManager
{
    static DataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[DataManager alloc] init];
    });
    
    return _sharedManager;
}

- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    self = [super init];
    if (self)
    {
        _persistentStoreCoordinator = persistentStoreCoordinator;
    }
    return self;
}

//TODO: esto puede tardar 13 segundos. Usar una base sqlite precargada en vez de un csv.
- (void)prepopulateData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"centersVersion"] != CENTERS_VERSION)
    {
        CFTimeInterval startTime = CACurrentMediaTime();
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Center"];
        NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
        
        NSError *deleteError = nil;
        [self.persistentStoreCoordinator executeRequest:delete withContext:self.managedObjectContext error:&deleteError];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"oficinas" ofType:@"csv"];
        NSArray *rows = [NSArray arrayWithContentsOfDelimitedURL:[NSURL fileURLWithPath:path] options:CHCSVParserOptionsTrimsWhitespace delimiter:';' error:nil];
        [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Center *entry = (Center*)[NSEntityDescription insertNewObjectForEntityForName:@"Center" inManagedObjectContext:self.managedObjectContext];
            [entry loadFromArray:obj];
        }];
        
        [self saveContext];
        
        CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
        NSLog(@"total %f", elapsedTime);
        
        [defaults setInteger:CENTERS_VERSION forKey:@"centersVersion"];
        [defaults synchronize];
    }
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        @try
        {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
            {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"Error saving context: %@", exception);
        }
    }
}

- (NSURL*)storeUrl
{
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"model.sqlite"];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeUrl options:nil error:&error])
    {
        [[NSFileManager defaultManager] removeItemAtURL:self.storeUrl error:nil];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeUrl options:nil error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark Notification

- (Notification*)getNotificationWithPredicate:(NSPredicate*)predicate create:(BOOL)create error:(NSError **)error
{
    Notification *entry = nil;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:predicate];
    
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:error];
    if(!isEmpty(result))
    {
        entry = (Notification*)[result objectAtIndex:0];
    }
    else if(create)
    {
        entry = (Notification*)[NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:self.managedObjectContext];
    }
    
    return entry;
}

- (Notification*)getNotificationWithId:(NSString*)uid error:(NSError **)error
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uid == %@)", uid];
    return [self getNotificationWithPredicate:predicate create:NO error:error];
}

- (Notification*)getOrCreateNotificationWithId:(NSString*)uid error:(NSError **)error
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uid == %@)", uid];
    return [self getNotificationWithPredicate:predicate create:YES error:error];
}

- (Notification*)getOrCreateNotificationWithDictionary:(NSDictionary*)dictionary error:(NSError **)error
{
    if(isEmpty(dictionary))
    {
        return nil;
    }
    
    NSString *uid = [dictionary getStringForKey:@"_id"];
    Notification *obj = [self getOrCreateNotificationWithId:uid error:error];
    [obj loadFromDictionary:dictionary];
    return obj;
}

- (void)deleteAllNotifications
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Notification"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [self.persistentStoreCoordinator executeRequest:delete withContext:self.managedObjectContext error:&deleteError];
    
}

#pragma mark Center

- (Center*)getCenterWithPredicate:(NSPredicate*)predicate create:(BOOL)create error:(NSError **)error
{
    Center *entry = nil;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Center" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:predicate];
    
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:error];
    if(!isEmpty(result))
    {
        entry = (Center*)[result objectAtIndex:0];
    }
    else if(create)
    {
        entry = (Center*)[NSEntityDescription insertNewObjectForEntityForName:@"Center" inManagedObjectContext:self.managedObjectContext];
    }
    
    return entry;
}

- (Center*)getCenterWithId:(NSString*)uid error:(NSError **)error
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uid == %@)", uid];
    return [self getCenterWithPredicate:predicate create:NO error:error];
}

- (Center*)getOrCreateCenterWithId:(NSString*)uid error:(NSError **)error
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uid == %@)", uid];
    return [self getCenterWithPredicate:predicate create:YES error:error];
}

- (Center*)getOrCreateCenterWithDictionary:(NSDictionary*)dictionary error:(NSError **)error
{
    if(isEmpty(dictionary))
    {
        return nil;
    }
    
    NSString *uid = [dictionary getStringForKey:@"id"];
    Center *obj = [self getOrCreateCenterWithId:uid error:error];
    [obj loadFromDictionary:dictionary];
    return obj;
}

- (Center*)getOrCreateCenterWithArray:(NSArray*)array error:(NSError **)error
{
    if(isEmpty(array))
    {
        return nil;
    }
    
    NSString *uid = array[0];
    Center *obj = [self getOrCreateCenterWithId:uid error:error];
    [obj loadFromArray:array];
    return obj;
}


#pragma mark debug

- (void)debugLogEntityWithName:(NSString*)name
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableString *debugString = [NSMutableString string];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *info in fetchedObjects)
    {
        [debugString appendFormat:@"\t%@\n", info];
    }
    NSLog(@"\n%@:\n[\n%@]\n", name, debugString);
}


@end
