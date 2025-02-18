import JitsiMeetSDK
import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: ContentView())
        window.makeKeyAndVisible()
        self.window = window

        let defaultOptions = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.serverURL = URL(string: "https://alpha.jitsi.net")
            builder.setFeatureFlag("welcomepage.enabled", withValue: false)
        }
        JitsiMeet.sharedInstance().defaultConferenceOptions = defaultOptions

        guard let launchOptions = launchOptions else { return false }
        return JitsiMeet.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

@main   
struct JitsiSwiftUIDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
