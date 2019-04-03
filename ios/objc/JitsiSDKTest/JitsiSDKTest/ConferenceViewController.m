
#import "ConferenceViewController.h"

@interface ConferenceViewController ()

@end

@implementation ConferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Attach this controller as the delegate.
    JitsiMeetView *jitsiView = (JitsiMeetView*)self.view;
    jitsiView.delegate = self;
    
    // Join the room.
    JitsiMeetConferenceOptions *options
        = [JitsiMeetConferenceOptions fromBuilder:^(JitsiMeetConferenceOptionsBuilder *builder) {
            builder.room = self.room;
        }];
    [jitsiView join:options];
}

- (void)conferenceWillJoin:(NSDictionary *)data {
    NSLog(@"About to join conference %@", self.room);
}

- (void)conferenceJoined:(NSDictionary *)data {
    NSLog(@"Conference %@ joined", self.room);
}

- (void)conferenceTerminated:(NSDictionary *)data {
    NSLog(@"Conference %@ terminated", self.room);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

