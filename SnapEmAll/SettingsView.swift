import SwiftUI

/// A custom button style for settings navigation buttons.
struct SettingsButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity) // Button stretches horizontally to fill available space.
            .padding() // Adds padding inside the button for spacing.
            .background(Color.blue) // Sets the button background color to blue.
            .foregroundColor(.white) // Sets the button text color to white.
            .cornerRadius(10) // Adds rounded corners to the button.
    }
}

/// A view for the main settings screen, allowing navigation to different settings categories.
struct SettingsView: View {
    var body: some View {
        VStack {
            // Navigation link to the "Account Settings" page.
            NavigationLink("Account", destination: AccountSettingsView())
                .buttonStyle(SettingsButton()) // Applies the custom button style.

            // Navigation link to the "Accessibility Settings" page.
            NavigationLink("Accessibility", destination: AccessibilitySettingsView())
                .buttonStyle(SettingsButton()) // Applies the custom button style.

            // Navigation link to the "Notifications Settings" page.
            NavigationLink("Notifications", destination: NotificationsSettingsView())
                .buttonStyle(SettingsButton()) // Applies the custom button style.

            // Navigation link to the "Camera Settings" page.
            NavigationLink("Camera", destination: CameraSettingsView())
                .buttonStyle(SettingsButton()) // Applies the custom button style.
        }
        .padding() // Adds padding around the list of buttons.
        Spacer() // Adds flexible space to push the content to the top of the screen.
        .navigationTitle("Settings") // Sets the navigation bar title.
        .navigationBarTitleDisplayMode(.inline) // Displays the title in a compact inline style.
    }
}

#Preview {
    SettingsView()
}
