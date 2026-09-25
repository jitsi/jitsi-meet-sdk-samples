import SwiftUI
import UIKit
import JitsiMeetSDK


struct JitsiMeetViewWrapper: UIViewRepresentable {
    var room: String
    var readyToClose: () -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> JitsiMeetView {
        let view = JitsiMeetView()
        view.delegate = context.coordinator
        
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.room = room
        }
        
        // Make sure the React Native runtime is up before joining.
        JitsiMeet.sharedInstance().instantiateReactNative()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            view.join(options)
        }
        return view
    }

    func updateUIView(_ uiView: JitsiMeetView, context: Context) {
        // Update the view when SwiftUI state changes (if necessary)
    }

    static func dismantleUIView(_ uiView: JitsiMeetView, coordinator: Coordinator) {
        // Free the React Native runtime once the conference view is gone.
        JitsiMeet.sharedInstance().destroyReactNative()
    }
    
    class Coordinator: NSObject, JitsiMeetViewDelegate {
        var parent: JitsiMeetViewWrapper
        
        init(_ parent: JitsiMeetViewWrapper) {
            self.parent = parent
        }
     
        func ready(toClose data: [AnyHashable : Any]!) {
            print("Ready to close!")
            DispatchQueue.main.async {
                self.parent.readyToClose()
            }
        }
    }
}
