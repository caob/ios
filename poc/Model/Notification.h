#import "_Notification.h"

typedef enum
{
    kNotificationTypeMessage,
    kNotificationTypeLink,
    kNotificationTypeInnerId
} kNotificationType;

typedef enum
{
    kNotificationCategoryInfo,
    kNotificationCategoryPromotion,
    kNotificationCategoryNews
} kNotificationCategory;

typedef enum
{
    kNotificationInnerIdNone = -1,
    kNotificationInnerIdInbox,
    kNotificationInnerIdCenters,
    kNotificationInnerIdProfile,
    kNotificationInnerIdAbout
} kNotificationInnerId;

@interface Notification : _Notification

- (void)loadFromDictionary:(NSDictionary*)dictionary;

@end
