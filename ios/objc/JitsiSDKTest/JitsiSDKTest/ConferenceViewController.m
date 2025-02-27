
#import "ConferenceViewController.h"

@interface ConferenceViewController ()

@end

@implementation ConferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.room == nil) {
        NSLog(@"Room is nul!");

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });

        return;
    }

    // Attach this controller as the delegate.
    JitsiMeetView *jitsiView = (JitsiMeetView*)self.view;
    jitsiView.delegate = self;

    // Join the room.
    JitsiMeetConferenceOptions *options
        = [JitsiMeetConferenceOptions fromBuilder:^(JitsiMeetConferenceOptionsBuilder *builder) {
            builder.room = self.room;
            // Settings for audio and video
            //builder.audioMuted = YES;
            // builder.videoMuted = YES;
            // Set different feature flags
            [builder setFeatureFlag:@"add-people.enabled" withBoolean:NO];
            [builder setFeatureFlag:@"filmstrip.enabled" withBoolean:YES];
            // [builder setConfigOverride:@"customToolbarButtons" withArray:@[
            //   @{
            //       @"icon": @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAFISURBVHgBxVWBcYMwDJQ7QbuBu4FHcDfoBvEGZQOSicgGdIPQCWADRnClQ76qYFE7Vy5/J3yRXpKlCAFwMEwJKcbo8CCxrJpQBmPMAPcCgz6jtChz1DGifBC3NrhnZ0KPElCsrIh1nUjkS4OfapwosbjM6S+yZ+Ktpmxu5419/R5pZKnraYk/Khu+gYU7ITpwTjojjCMeXzh675ozLKNKuCJvUng98dD+IpWOMwfFqY1btAo3sN3tK39sNurwO/xAv59Yb+mhvJnZljE2FxKtszLBYUgJJnooE7S3b65rhWjzJBOkIH7tgCV/4nGBLS7KJDkZU47pDMuGfMs4perS/zFw4hyvg2VMX9eGszYZpRAT1OSMx64KJh237AQ5vXRjLNhL8fe3I0AJVk4dJ3XCblnXi8t4qAGX3YhEOcw8HGo7H/fR/y98AzFrGjU3gjYAAAAAAElFTkSuQmCC",
            //       @"id": @"record"
            //   },
            //   @{
            //       @"icon": @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAFRSURBVHgB1VTRcYMwDBWdgBG8QTMCGzQbNBuUDWCDsgHZICPQDdINSCcgncCV7p5bVXHADpePvDsdRBbvyX5yiO6MIqXIe+/4UXE4pD4liqI40RowccUx+OsYIH4TeQOSiaPVRPy+4dhxjKhpKAeKfM9RztSVqBHUlALpFB8cKBFSi29cSvEeW3dGdMBxSfRmvUR+uSl00hvyEQSdamDUx4e1ae5Ig3mCF/Ohj+xI0KrcDrmN5nwyGkH9W+WeOT70zONd7oImOxmOqMAZT6dyX4bINmN/n+kalFmdylVh1nE0UvOO3KuqE28mWgJGbjIGtv4SrVoPg9CnCETvAfJviCrS1L9BWBKpw7Ek1DZ2R6kiYTy3MzVb1HSUC5h5hB8usu6wdqRbocwbjek672gN/N/tHlTuELu1a0R+TVempv09Z4h06g7km5ooUmeP48PjBzBGLGGSG2WSAAAAAElFTkSuQmCC",
            //       @"id": @"location"
            //   },
            //   @{
            //       @"icon": @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAErSURBVHgBvZWNEYIwDIWD5yCOwAiwAW6AG7gBMAmM4AawAW6gGzhCTc7Ahf6dbdF3J7208X1tWgrAj5XJQClVYFNAmu5Zlt2MXjTv1X7qdfOKB1pIFHmwV2F0QqDIhP9baf3rZI8QKS5DLeIBa3/R8w4QZ16xeYemdFA6ijdlSQGgcnqgdytbsJzAWMBED5xxI1vUbM12bTJ25eAQ1Vw7moMYWzf54DGgWc1idhthWWpszvCpf8kxfLUCMuVZjNw2ECC5AgMgzFs5JiGc88DfKQigmzvGl5yXC+IDGOauHDJmgAHxAazmWt5VxFaIdw9CZYNIQOyLtgqP5xObksNRL1cywAbZHWCBGICJHirwhXJAls/l9l5S5t2SomGFahC653NI04QrmeBfegPEpC4OSSpfkQAAAABJRU5ErkJggg==",
            //       @"id": @"screenshot"
            //   },
            //   @{
            //       @"icon": @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAADSSURBVHgB7VTRCcJADE3BAeoGHcFNdAPdwG7QbqBO0G7gCHaD4gR1BJ0gvsOAIl5jAkd/+uDRwr33cuTuQjQjFZi5BStKBSnAkxdZKAEFPmtwGZHcwDtYQ/vIsuxIht3t2YazJXwnptCCfES3FV0/pvtlvICDovGFi3kAG0XTu8LFHFq0UjS5KzwWpqwXYEnO8CY0WtGUch4FecKBWtG12qVwhcs5HP7ZxLexYhuiLzg2Kq4f/yd6jYMYOoyIjqzg92v23XVrEUoFhG/YMshmWPEEwndJv9jtUaIAAAAASUVORK5CYII=",
            //       @"id": @"swap-camera"
            //   },
            //   @{
            //       @"backgroundColor": @"red",
            //       @"icon": @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAACESURBVHgB7ZRLDoAgDESL8b7iCfQIXtUTjDSyYMGnhe7gJSTGTOcl2kC0mBMARziXMu+leR7w+GlKOBOzN2nggZaku1wiGS6vSczKcxLz8oxEVb6RHBSex0k/CwTb1V2evLOR1H7osASCbemWQLGKiSR7F+2FuTec0zn3UIOQYQEtJuYDedv/MgzzIYUAAAAASUVORK5CYII=",
            //       @"id": @"close"
            //   }
            // ]];
            // [builder setConfigOverride:@"toolbarButtons" withArray:@[@"record", @"location", @"screenshot", @"swap-camera", @"close"]];
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
}

- (void)readyToClose:(NSDictionary *)data {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)customButtonPressed:(NSDictionary *)data {
    NSLog(@"Custom button pressed %@", data);
}

@end
