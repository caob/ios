
#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSDate *birthday;

@property (strong, nonatomic, readonly) NSString *fullName;

@property (assign, nonatomic) BOOL isMale;
@property (assign, nonatomic) BOOL isFemale;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (void)loadFromDictionary:(NSDictionary*)dictionary;

- (NSString *)dateToString:(NSDate *)date;
- (NSDate *)stringToDate:(NSString *)date;


@end
