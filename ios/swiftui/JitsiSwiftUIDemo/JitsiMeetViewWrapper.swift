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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            view.join(options)
        }
        return view
    }

    func updateUIView(_ uiView: JitsiMeetView, context: Context) {
        // Update the view when SwiftUI state changes (if necessary)
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
