
#import <AFNetworking/AFNetworking.h>

@interface RequestManager : AFHTTPSessionManager

+ (RequestManager*)sharedManager;

@end


