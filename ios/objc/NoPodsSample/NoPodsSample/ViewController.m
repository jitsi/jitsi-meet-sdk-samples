
#import "ViewController.h"
#import "ConferenceViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.room = nil;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    // Don't present the ConferenceViewController if no room was specified.
    if ([identifier isEqualToString:@"joinConference"]) {
        self.room = self.textField.text;
        if (self.room == nil || [self.room length] == 0) {
            return NO;
        }
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"joinConference"]) {
        // Attach the room to the new controller.
        ConferenceViewController *vc = [segue destinationViewController];
        vc.room = self.room;
    }
}

@end
