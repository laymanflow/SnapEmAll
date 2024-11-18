//
//  NotificationsSettingsView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 11/5/24.
//
import SwiftUI

/// A view that allows users to manage their notification preferences for the SnapEmAll app.
struct NotificationsSettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Notifications Settings")
                .font(.largeTitle)
                .padding()

            // Informational text describing the purpose of the view.
            Text("Manage notification preferences for SnapEmAll.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            // Button to open the system notification settings for the app.
            Button(action: openNotificationSettings) {
                Text("Open Notification Settings")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue) // Sets the button background color to blue.
                    .foregroundColor(.white) // Sets the button text color to white.
                    .cornerRadius(10) // Rounds the button corners for a smooth appearance.
            }
            .padding(.horizontal) // Adds horizontal padding around the button.

            Spacer() // Pushes the content upwards to avoid crowding.
        }
        .padding() // Adds padding around the entire view.
    }

    /// Opens the system notification settings for the app.
    func openNotificationSettings() {
        // Retrieves the URL for the system settings page for the app.
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return // Exits if the URL cannot be created.
        }
        // Checks if the system can open the settings URL and opens it if possible.
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    NotificationsSettingsView()
}
