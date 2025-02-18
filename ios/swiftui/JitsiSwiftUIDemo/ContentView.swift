import SwiftUI

struct RoomData: Hashable {
    let room: String
}

struct ContentView: View {
    @State private var room: String = ""
    @State private var path = NavigationPath()

    func join() {
        guard !room.isEmpty else {
            return
        }
        let roomData = RoomData(room: room)
        path.append(roomData)
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                TextField(
                    "Enter room name",
                    text: $room
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                Button(action: join) {
                    Text("Join")
                }
            }
            .padding(50)
            .navigationDestination(for: RoomData.self) { roomData in
                MeetingView(path: $path ,room: roomData.room)
            }
        }
    }
}

#Preview {
    ContentView()
}
