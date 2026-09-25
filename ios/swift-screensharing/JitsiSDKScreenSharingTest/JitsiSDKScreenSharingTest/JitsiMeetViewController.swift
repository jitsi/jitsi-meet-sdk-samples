//
//  ViewController.swift
//  JitsiSDKTest
//
//  Created by Alex-Dan Bumbu on 17.05.2021.
//

import UIKit
import JitsiMeetSDK

class JitsiMeetViewController: UIViewController {
    
    var meetingName: String!
    
    @IBOutlet private var meetView: JitsiMeetView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        meetView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        joinMeeting(name: meetingName)
    }
    
    private func joinMeeting(name: String) {
        let options = JitsiMeetConferenceOptions.fromBuilder { builder in
            builder.room = name
            builder.userInfo = JitsiMeetUserInfo(displayName: "Test User", andEmail: nil, andAvatar: nil)
            
            builder.setAudioMuted(true)
            builder.setVideoMuted(true)
            
            builder.setFeatureFlag("ios.screensharing.enabled", withBoolean: true)

        }

        // Make sure the React Native runtime is up before joining.
        JitsiMeet.sharedInstance().instantiateReactNative()

        meetView.join(options)
    }
}

extension JitsiMeetViewController: JitsiMeetViewDelegate {

    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        dismiss(animated: true) {
            // Free the React Native runtime once the conference view is gone.
            JitsiMeet.sharedInstance().destroyReactNative()
        }
    }
}

