
#import <UIKit/UIKit.h>

@import JitsiMeetSDK;


@interface ConferenceViewController : UIViewController<JitsiMeetViewDelegate>

@property (nonatomic, weak) NSString *room;

@end
