import SwiftUI
import FirebaseCore
import FirebaseAuth
import UserNotifications
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        FirebaseConfiguration.shared.setLoggerLevel(.debug) // Enable Firebase debug logging
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications permission: \(error.localizedDescription)")
            } else {
                print("Notifications permission granted: \(granted)")
            }
        }
        
        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully registered for remote notifications: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received remote notification: \(userInfo)")
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Foreground notification received: \(notification.request.content.userInfo)")
        completionHandler([.alert, .sound])
    }
}

@main
struct SnapEmAllApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("textSize") private var textSize: Double = 16.0

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, isDarkMode ? .dark : .light)
                .environment(\.sizeCategory, sizeCategory(for: textSize))
        }
    }

    private func sizeCategory(for textSize: Double) -> ContentSizeCategory {
        switch textSize {
        case 12...15:
            return .small
        case 16...18:
            return .medium
        case 19...21:
            return .large
        case 22...25:
            return .extraLarge
        case 26...30:
            return .extraExtraLarge
        default:
            return .medium
        }
    }
}
