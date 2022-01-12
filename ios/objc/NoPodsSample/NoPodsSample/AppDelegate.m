
#import "AppDelegate.h"

@import JitsiMeetSDK;


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Initialize default options for joining conferences.
    JitsiMeetConferenceOptions *defaultOptions
        = [JitsiMeetConferenceOptions fromBuilder:^(JitsiMeetConferenceOptionsBuilder *builder) {
            builder.serverURL = [NSURL URLWithString:@"https://meet.jit.si"];
            [builder setFeatureFlag:@"welcomepage.enabled" withBoolean:NO];
        }];
    [JitsiMeet sharedInstance].defaultConferenceOptions = defaultOptions;

    return YES;
}

@end
