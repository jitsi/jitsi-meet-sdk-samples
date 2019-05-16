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
    
    [JMCallKitProxy addListener:self];
    self.textField.delegate = self;
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

- (IBAction)simulateIncomingCall:(id)sender {
    NSLog(@"Simulating incoming call");
    
    NSString *room = self.textField.text;
    if (!room || room.length == 0) {
        return;
    }
    
    NSUUID *uuid = [NSUUID UUID];
    NSString *handle = [NSString stringWithFormat:@"https://meet.jit.si/%@", room];
    NSString *displayName = @"Fellow Jitster";
    
    [JMCallKitProxy reportNewIncomingCallWithUUID:uuid
                                           handle:handle
                                      displayName:displayName
                                         hasVideo:YES
                                       completion:(^(NSError *error) {
                                            NSLog(@"Error: %@", error);
                                       })];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return NO;
}

#pragma mark - JMCallKitListener

- (void)performAnswerCallWithUUID:(NSUUID *)UUID {
    NSLog(@"performAnswerCallWithUUID: %@", UUID);
    NSString *uuidStr = [[UUID UUIDString] uppercaseString];
    NSString *url = [NSString stringWithFormat:@"https://meet.jit.si/%@#config.callUUID=%@", self.textField.text, uuidStr];
    
    // Join the conference!
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConferenceViewController *vc = [sb instantiateViewControllerWithIdentifier:@"conferenceViewController"];
    vc.room = url;
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
