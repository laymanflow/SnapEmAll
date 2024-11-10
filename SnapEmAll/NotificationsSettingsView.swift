//
//  NotificationsSettingsView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 11/5/24.
//
import SwiftUI

struct NotificationsSettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Notifications Settings")
                .font(.largeTitle)
                .padding()

            Text("Manage notification preferences for SnapEmAll.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Button(action: openNotificationSettings) {
                Text("Open Notification Settings")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }

    // Function to open Notification Settings
    func openNotificationSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    NotificationsSettingsView()
}
