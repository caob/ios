
#ifndef Constants_h
#define Constants_h

#import "UIColor-Expanded.h"

#ifdef DEBUG
    #define DEBUG_BOOL                      true
    #define ROOT_URL                        @"https://backpocapp.herokuapp.com"
//    #define ROOT_URL                    @"http://localhost:8000"

#else
    #define DEBUG_BOOL                      false
    #define ROOT_URL                        @"https://backpocapp.herokuapp.com"

#endif

#define CENTERS_VERSION                     4

#define GAI_TRACKING_ID                     @"UA-85974138-1"

#define FORCE_VALID_SESSION                 (!true && DEBUG_BOOL)
#define CACHE_ENABLED                       (true || !DEBUG_BOOL)
#define GAI_DEBUG_ENABLED                   (!true && DEBUG_BOOL)


#define kNewsColor                          0x47bcff
#define kPromotionsColor                    0x02bc41
#define kAppInfoColor                       0xcf2a77

#define kPrimaryColor                       0xEFD805
#define kPrimaryDarkColor                   0xEFB805

#define kLightTextColor                     0xFFFFFF
#define kGrayTextColor                      0x7d8496
#define kDarkTextColor                      0x444444

#define kDefaultButtonCornerRadius          20
#define kDefaultButtonTintColor             0xFFFFFF
#define kDefaultButtonTintHighlightedColor  0xFFFFFF
#define kDefaultButtonColor                 kPrimaryDarkColor
#define kDefaultButtonHighlightedColor      kPrimaryColor


#endif /* Constants_h */
