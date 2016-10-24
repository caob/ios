

#import "RequestManager.h"
#import "Constants.h"

@implementation RequestManager

+ (RequestManager*)sharedManager
{
    static RequestManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[RequestManager alloc] initWithBaseURL:[NSURL URLWithString:ROOT_URL]];
    });
    return _sharedManager;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}


@end
