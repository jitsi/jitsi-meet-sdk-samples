
#import "ConferenceViewController.h"
#import "JitsiMeetSDK/JitsiMeetSDK.h"

@interface ConferenceViewController ()

@end

@implementation ConferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JMCallKitProxy.enabled = YES;

    if (self.room == nil) {
        NSLog(@"Room is nul!");

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });

        return;
    }
    
    [JMCallKitProxy addListener:self];
    
    [JMCallKitProxy reportNewIncomingCallWithUUID:[NSUUID UUID] handle:self.room displayName:self.room hasVideo:YES completion:^(NSError * _Nullable error) {
        NSLog(@"Incoming call reported!");
    }];
}

- (void)providerDidReset {
    
}

- (void)providerDidActivateAudioSessionWithSession:(AVAudioSession *)session {
    
}

- (void)providerTimedOutPerformingActionWithAction:(CXAction *)action {
    
}

- (void)providerDidDeactivateAudioSessionWithSession:(AVAudioSession *)session {
    
}

- (void)performAnswerCallWithUUID:(nonnull NSUUID *)UUID {
    
    NSLog(@"Call answered!");

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"Call answered finalized!");
        
        // Attach this controller as the delegate.
        JitsiMeetView *jitsiView = (JitsiMeetView*)self.view;
        jitsiView.delegate = self;
    
        // Join the room.
        JitsiMeetConferenceOptions *options
            = [JitsiMeetConferenceOptions fromBuilder:^(JitsiMeetConferenceOptionsBuilder *builder) {
                builder.room = self.room;
                // Settings for audio and video
                // builder.audioMuted = YES;
                // builder.videoMuted = YES;
                // Set different feature flags
                // [builder setFeatureFlag:@"toolbox.enabled" withBoolean:NO];
                // [builder setFeatureFlag:@"filmstrip.enabled" withBoolean:NO];
                [builder setConfigOverride:@"callUUID" withValue: UUID.UUIDString];
                [builder setConfigOverride:@"callHandle" withValue: self.room];
            }];
        [jitsiView join:options];
    });
}

- (void) performStartCallWithUUID:(NSUUID *)UUID isVideo:(BOOL)isVideo{
    
}


- (void)conferenceWillJoin:(NSDictionary *)data {
    NSLog(@"About to join conference %@", self.room);
}

- (void)conferenceJoined:(NSDictionary *)data {
    NSLog(@"Conference %@ joined", self.room);
}

- (void)conferenceTerminated:(NSDictionary *)data {
    NSLog(@"Conference %@ terminated", self.room);
}

- (void)readyToClose:(NSDictionary *)data {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
