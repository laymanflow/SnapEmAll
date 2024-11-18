import SwiftUI
import FirebaseCore
import FirebaseAuth
import UserNotifications
import FirebaseFirestore

// AppDelegate class handles Firebase setup, and app-level configuration
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    // Called when the application finishes launching. Sets up Firebase, notification permissions, and remote notifications.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure() // Initialize Firebase
        FirebaseConfiguration.shared.setLoggerLevel(.debug) // Enable Firebase debug logging
        
        // Request user permissions for notifications (alert, badge, sound)
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications permission: \(error.localizedDescription)")
            } else {
                print("Notifications permission granted: \(granted)")
            }
        }
        
        application.registerForRemoteNotifications() // Register the app for remote notifications
        return true
    }

    // Called when the app successfully registers for remote notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully registered for remote notifications: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
    }

    // Called when registration for remote notifications fails
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }

    // Handles incoming remote notifications and determines whether Firebase can process them
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received remote notification: \(userInfo)")
        if Auth.auth().canHandleNotification(userInfo) { // Check if Firebase Auth can handle the notification
            completionHandler(.newData) // Notify the system that the notification was handled
        } else {
            completionHandler(.noData) // Notify the system that no data was fetched
        }
    }

    // Handles notifications received while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Foreground notification received: \(notification.request.content.userInfo)")
        completionHandler([.alert, .sound]) // Present the notification with an alert and sound
    }
}

// Main application entry point
@main
struct SnapEmAllApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate // Assign the AppDelegate to handle app-level events
    
    @AppStorage("isDarkMode") private var isDarkMode = false // App-wide setting for dark mode
    @AppStorage("textSize") private var textSize: Double = 16.0 // App-wide setting for text size

    var body: some Scene {
        WindowGroup {
            ContentView() // Launch the ContentView as the initial view
                .environment(\.colorScheme, isDarkMode ? .dark : .light) // Apply dark mode globally
                .environment(\.sizeCategory, sizeCategory(for: textSize)) // Adjust text size globally
        }
    }

    // Helper function to map text size to dynamic type categories for system-wide adjustments
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
            return .medium // Default to medium if the size is out of bounds
        }
    }
}
