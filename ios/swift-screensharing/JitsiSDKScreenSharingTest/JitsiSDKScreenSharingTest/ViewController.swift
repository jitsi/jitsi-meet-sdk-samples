//
//  ViewController.swift
//  JitsiSDKScreenSharingTest
//
//  Created by Alex-Dan Bumbu on 04.06.2021.
//

import UIKit

private enum Segue: String {
    case showMeeting
}

class ViewController: UIViewController {
    
    @IBOutlet private var meetingNameInput: UITextField!
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Segue.showMeeting.rawValue {
            guard let meetingName = meetingNameInput.text, meetingName.count > 0 else {
                print("Enter meeting name")
                return false
            }
            
            return true
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.showMeeting.rawValue {
            let navController = segue.destination as! UINavigationController
            let meetingsController = navController.viewControllers.first as! JitsiMeetViewController
            meetingsController.meetingName = meetingNameInput.text!
        }
    }
}

