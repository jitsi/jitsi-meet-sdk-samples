/*
 * Copyright @ 2017-present 8x8, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import JitsiMeetSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var videoButton: UIButton?
    @IBOutlet weak var roomName: UITextField!
    
    fileprivate var pipViewCoordinator: PiPViewCoordinator?
    fileprivate var jitsiMeetView: JitsiMeetView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultOptions = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            // for JaaS replace url with https://8x8.vc
            builder.serverURL = URL(string: "https://meet.jit.si/")
            // for JaaS use the obtained Jitsi JWT
            // builder.token = "SampleJWT"
            builder.setFeatureFlag("welcomepage.enabled", withValue: false)
            // Set different feature flags
            // builder.setFeatureFlag("toolbox.enabled", withBoolean: false)
            // builder.setFeatureFlag("filmstrip.enabled", withBoolean: false)
            // builder.setConfigOverride("customToolbarButtons", with: [
            //     [
            //         "icon": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAFISURBVHgBxVWBcYMwDJQ7QbuBu4FHcDfoBvEGZQOSicgGdIPQCWADRnClQ76qYFE7Vy5/J3yRXpKlCAFwMEwJKcbo8CCxrJpQBmPMAPcCgz6jtChz1DGifBC3NrhnZ0KPElCsrIh1nUjkS4OfapwosbjM6S+yZ+Ktpmxu5419/R5pZKnraYk/Khu+gYU7ITpwTjojjCMeXzh675ozLKNKuCJvUng98dD+IpWOMwfFqY1btAo3sN3tK39sNurwO/xAv59Yb+mhvJnZljE2FxKtszLBYUgJJnooE7S3b65rhWjzJBOkIH7tgCV/4nGBLS7KJDkZU47pDMuGfMs4perS/zFw4hyvg2VMX9eGszYZpRAT1OSMx64KJh237AQ5vXRjLNhL8fe3I0AJVk4dJ3XCblnXi8t4qAGX3YhEOcw8HGo7H/fR/y98AzFrGjU3gjYAAAAAAElFTkSuQmCC",
            //         "id": "CUSTOM_BTN_ID_1"
            //     ],
            //     [
            //         "icon": "data:image/png;base64,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",
            //         "id": "CUSTOM_BTN_ID_2"
            //     ],
            //     [
            //         "icon": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAFISURBVHgBxVWBcYMwDJQ7QbuBu4FHcDfoBvEGZQOSicgGdIPQCWADRnClQ76qYFE7Vy5/J3yRXpKlCAFwMEwJKcbo8CCxrJpQBmPMAPcCgz6jtChz1DGifBC3NrhnZ0KPElCsrIh1nUjkS4OfapwosbjM6S+yZ+Ktpmxu5419/R5pZKnraYk/Khu+gYU7ITpwTjojjCMeXzh675ozLKNKuCJvUng98dD+IpWOMwfFqY1btAo3sN3tK39sNurwO/xAv59Yb+mhvJnZljE2FxKtszLBYUgJJnooE7S3b65rhWjzJBOkIH7tgCV/4nGBLS7KJDkZU47pDMuGfMs4perS/zFw4hyvg2VMX9eGszYZpRAT1OSMx64KJh237AQ5vXRjLNhL8fe3I0AJVk4dJ3XCblnXi8t4qAGX3YhEOcw8HGo7H/fR/y98AzFrGjU3gjYAAAAAAElFTkSuQmCC",
            //         "id": "CUSTOM_BTN_ID_3"
            //     ],
            //     [
            //         "icon": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAFISURBVHgBxVWBcYMwDJQ7QbuBu4FHcDfoBvEGZQOSicgGdIPQCWADRnClQ76qYFE7Vy5/J3yRXpKlCAFwMEwJKcbo8CCxrJpQBmPMAPcCgz6jtChz1DGifBC3NrhnZ0KPElCsrIh1nUjkS4OfapwosbjM6S+yZ+Ktpmxu5419/R5pZKnraYk/Khu+gYU7ITpwTjojjCMeXzh675ozLKNKuCJvUng98dD+IpWOMwfFqY1btAo3sN3tK39sNurwO/xAv59Yb+mhvJnZljE2FxKtszLBYUgJJnooE7S3b65rhWjzJBOkIH7tgCV/4nGBLS7KJDkZU47pDMuGfMs4perS/zFw4hyvg2VMX9eGszYZpRAT1OSMx64KJh237AQ5vXRjLNhL8fe3I0AJVk4dJ3XCblnXi8t4qAGX3YhEOcw8HGo7H/fR/y98AzFrGjU3gjYAAAAAAElFTkSuQmCC",
            //         "id": "CUSTOM_BTN_ID_4"
            //     ],
            //     [
            //         "backgroundColor": "red",
            //         "icon": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAFISURBVHgBxVWBcYMwDJQ7QbuBu4FHcDfoBvEGZQOSicgGdIPQCWADRnClQ76qYFE7Vy5/J3yRXpKlCAFwMEwJKcbo8CCxrJpQBmPMAPcCgz6jtChz1DGifBC3NrhnZ0KPElCsrIh1nUjkS4OfapwosbjM6S+yZ+Ktpmxu5419/R5pZKnraYk/Khu+gYU7ITpwTjojjCMeXzh675ozLKNKuCJvUng98dD+IpWOMwfFqY1btAo3sN3tK39sNurwO/xAv59Yb+mhvJnZljE2FxKtszLBYUgJJnooE7S3b65rhWjzJBOkIH7tgCV/4nGBLS7KJDkZU47pDMuGfMs4perS/zFw4hyvg2VMX9eGszYZpRAT1OSMx64KJh237AQ5vXRjLNhL8fe3I0AJVk4dJ3XCblnXi8t4qAGX3YhEOcw8HGo7H/fR/y98AzFrGjU3gjYAAAAAAElFTkSuQmCC",
            //         "id": "CUSTOM_BTN_ID_5"
            //     ]
            // ])
            // builder.setConfigOverride("toolbarButtons", with: [
            //     "CUSTOM_BTN_ID_1", "CUSTOM_BTN_ID_2", "CUSTOM_BTN_ID_3", "CUSTOM_BTN_ID_4", "CUSTOM_BTN_ID_5", "overflowmenu", "hangup"
            // ])
        }
        
        JitsiMeet.sharedInstance().defaultConferenceOptions = defaultOptions
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let rect = CGRect(origin: CGPoint.zero, size: size)
        // Reset view to provide bounds. It is required to do so
        // on rotation or screen size changes.
        pipViewCoordinator?.resetBounds(bounds: rect)
    }
    
    @IBAction func openJitsiMeet(sender: Any?) {
        let room: String = roomName.text!
        guard room.count > 1 else {
            return
        }
        
        // create and configure jitsimeet view
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            // for JaaS use <tenant>/<roomName> format
            builder.room = room
            // Settings for audio and video
            // builder.audioMuted = true;
            // builder.videoMuted = true;
        }
        
        // join room and display jitsi-call
        jitsiMeetView.join(options)
        
        // Enable jitsimeet view to be a view that can be displayed
        // on top of all the things, and let the coordinator to manage
        // the view state and interactions
        pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
        pipViewCoordinator?.configureAsStickyView(withParentView: view)

        // animate in
        jitsiMeetView.alpha = 0
        pipViewCoordinator?.show()
    }
    
    fileprivate func cleanUp() {
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
        pipViewCoordinator = nil
    }
}

extension ViewController: JitsiMeetViewDelegate {
    
    func ready(toClose data: [AnyHashable : Any]!) {
        self.pipViewCoordinator?.hide() { _ in
            self.cleanUp()
        }
    }
    
    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        self.pipViewCoordinator?.enterPictureInPicture()
    }
}
