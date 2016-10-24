
#import "User.h"
#import "NSDictionary-Expanded.h"

@implementation User

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
    [self setUid:[dictionary getStringForKey:@"id_str"]];
    [self setFirstName:[dictionary getStringForKey:@"nombre"]];
    [self setLastName:[dictionary getStringForKey:@"apellido"]];
    [self setPhoneNumber:[dictionary getStringForKey:@"phone_number"]];
    [self setBirthday:[self stringToDate:[dictionary getStringForKey:@"fecha_nacimiento"]]];
    [self setGender:[dictionary getStringForKey:@"sexo"]];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self != nil)
    {
        self.uid = [coder decodeObjectForKey:@"uid"];
        self.firstName = [coder decodeObjectForKey:@"firstName"];
        self.lastName = [coder decodeObjectForKey:@"lastName"];
        self.phoneNumber = [coder decodeObjectForKey:@"phoneNumber"];
        self.birthday = [coder decodeObjectForKey:@"birthday"];
        self.gender = [coder decodeObjectForKey:@"gender"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.uid forKey:@"uid"];
    [coder encodeObject:self.firstName forKey:@"firstName"];
    [coder encodeObject:self.lastName forKey:@"lastName"];
    [coder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [coder encodeObject:self.birthday forKey:@"birthday"];
    [coder encodeObject:self.gender forKey:@"gender"];
}

- (NSDateFormatter*)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy'/'MM'/'dd"];
    return dateFormatter;
}

- (NSString *)dateToString:(NSDate *)date
{
    return isEmpty(date)? @"": [[self dateFormatter] stringFromDate:date];
}

- (NSDate *)stringToDate:(NSString *)date
{
    return isEmpty(date)? nil: [[self dateFormatter] dateFromString:date];
}

- (void)setIsMale:(BOOL)isMale
{
    self.gender = @"M";
}

- (BOOL)isMale
{
    return [self.gender isEqualToString:@"M"];
}

- (void)setIsFemale:(BOOL)isFemale
{
    self.gender = @"F";
}

- (BOOL)isFemale
{
    return [self.gender isEqualToString:@"F"];
}

- (NSString*)fullName
{
    NSMutableArray *parts = [NSMutableArray array];
    if (!isEmpty(self.firstName)) [parts addObject:self.firstName];
    if (!isEmpty(self.lastName)) [parts addObject:self.lastName];
    
    return [parts componentsJoinedByString:@" "];
}


@end

