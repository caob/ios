
#import "LinkViewController.h"

@interface LinkViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation LinkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = self.notification.title;
//    NSURLRequestReturnCacheDataDontLoad
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.notification.link] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [self.webview loadRequest:request];
}

@end
