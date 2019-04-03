//
//  ViewController.m
//  JitsiSDKTest
//
//  Created by Saúl Ibarra Corretgé on 03/04/2019.
//  Copyright © 2019 Saúl Ibarra Corretgé. All rights reserved.
//

#import "ViewController.h"
#import "ConferenceViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    // Don't present the ConferenceViewController if no room was specified.
    if ([identifier isEqualToString:@"joinConference"]) {
        NSString *room = self.textField.text;
        if (room == nil || [room length] == 0) {
            return NO;
        }
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"joinConference"]) {
        // Attach the room to the new controller.
        ConferenceViewController *vc = [segue destinationViewController];
        vc.room = [self.textField text];
    }
}

@end
