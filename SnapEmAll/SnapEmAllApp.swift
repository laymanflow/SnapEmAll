import SwiftUI
import FirebaseCore
import FirebaseAuth
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Request notification permissions (for silent notifications during phone auth)
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications permission: \(error.localizedDescription)")
            }
        }
        
        // Register for remote notifications
        application.registerForRemoteNotifications()
        
        return true
    }

    // Handle notification registration for Firebase phone auth
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully registered for remote notifications.")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }

    // Required for Firebase phone auth notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Auth.auth().canHandleNotification(userInfo)
        completionHandler(.newData)
    }
    
    // Handle foreground notifications if needed
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

@main
struct SnapEmAllApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Global settings for dark mode and text size
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("textSize") private var textSize: Double = 16.0

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, isDarkMode ? .dark : .light)  // Apply dark mode globally
                .environment(\.sizeCategory, sizeCategory(for: textSize)) // Apply text size globally
        }
    }
    
    // Helper function to map text size to dynamic type categories
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
