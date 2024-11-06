import SwiftUI

struct SettingsButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct SettingsView: View {
    var body: some View {
        VStack {
            NavigationLink("Account", destination: AccountSettingsView())
                .buttonStyle(SettingsButton())
            
            NavigationLink("Accessibility", destination: AccessibilitySettingsView())
                .buttonStyle(SettingsButton())
            
            NavigationLink("Notifications", destination: NotificationsSettingsView())
                .buttonStyle(SettingsButton())
            
            NavigationLink("Camera", destination: CameraSettingsView())
                .buttonStyle(SettingsButton())
            
            NavigationLink("Wildlife Databases", destination: WildlifeDatabaseSettingsView())
                .buttonStyle(SettingsButton())
        }
        .padding()
        Spacer()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
}
