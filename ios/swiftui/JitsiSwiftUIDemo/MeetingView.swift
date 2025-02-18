import JitsiMeetSDK
import SwiftUI

struct MeetingView: View {
    @Binding var path: NavigationPath
    var room: String

    func readyToClose() {
        path.removeLast()
    }

    var body: some View {
        JitsiMeetViewWrapper(room: room, readyToClose: readyToClose)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}
