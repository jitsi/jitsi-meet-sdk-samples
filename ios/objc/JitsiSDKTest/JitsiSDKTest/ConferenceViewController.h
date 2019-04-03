
#import <UIKit/UIKit.h>

@import JitsiMeet;


@interface ConferenceViewController : UIViewController<JitsiMeetViewDelegate>

@property (nonatomic, weak) NSString *room;

@end
