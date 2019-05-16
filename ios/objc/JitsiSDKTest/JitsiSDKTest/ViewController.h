//
//  ViewController.h
//  JitsiSDKTest
//
//  Created by Saúl Ibarra Corretgé on 03/04/2019.
//  Copyright © 2019 Saúl Ibarra Corretgé. All rights reserved.
//

#import <UIKit/UIKit.h>

@import JitsiMeet;


@interface ViewController : UIViewController<UITextFieldDelegate, JMCallKitListener>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *joinButton;
@property (nonatomic, weak) IBOutlet UIButton *simulateButton;

@end
