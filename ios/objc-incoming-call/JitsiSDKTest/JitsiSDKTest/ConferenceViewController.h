
#import <UIKit/UIKit.h>

@import JitsiMeetSDK;


@interface ConferenceViewController : UIViewController<JitsiMeetViewDelegate, JMCallKitListener>

@property (nonatomic, weak) NSString *room;

@end
