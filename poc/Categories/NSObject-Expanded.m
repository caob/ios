
#import "NSObject-Expanded.h"

@implementation NSObject (NSObject_Expanded)

- (void)performBlock:(dispatch_block_t)block afterDelay:(NSTimeInterval)delay
{
    [self performSelector: @selector(_callBlock:)withObject: block afterDelay: delay];
}

- (void)performBlockOnMainThread:(dispatch_block_t)block
{
    dispatch_sync(dispatch_get_main_queue(), block);
}

- (void)performBlockInBackground:(dispatch_block_t)block
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(globalQueue, block);
}

- (BOOL)isEmpty
{
    return isEmpty(self);
}

#pragma mark - Private Methods

- (void)_callBlock:(dispatch_block_t)block
{
    block();
}

@end
