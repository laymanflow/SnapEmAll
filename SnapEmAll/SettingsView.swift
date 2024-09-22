//
//  SettingsView.swift
//  SnapEmAll
//
//  Created by Ethan Petrie on 9/19/24.
//

import SwiftUI

struct SettingsButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth:.infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            
    }
}

//Account settings view
struct AccountSettingsView: View {
    var body: some View {
        Text("Account Settings")
            .font(.largeTitle)
            .padding()
    }
}

//Accessibility settings view
//
// Permanent settings don't really translate well to the preview feature,
// but they still work.
//
struct AccessibilitySettingsView: View {
    
    //App storage keeps setting from resetting upon app restart
    @AppStorage("isDarkMode") private var isDarkMode = false;
    @AppStorage("textSize") private var textSize: Double = 16.0
    
    var body: some View {
        VStack{
            
            Text("Accessibility Settings")
                .font(.largeTitle)
                .padding()
            
            //Dark mode toggle
            Toggle(isOn: $isDarkMode) {
                Text("Dark Mode")
                    .font(.headline)
            }
            
            //Text size slider
            Text("Text Size")
                .font(.headline)
            Slider(value: $textSize, in: 12...30, step: 1)
            Text("Preview Text")
                .font(.system(size: CGFloat(textSize)))
                .padding()
            
            .padding()
            
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .padding()
        Spacer()
    }
    
}

//Notification settings view
struct NotificationsSettingsView: View {
    var body: some View {
        Text("Notifications Settings")
            .font(.largeTitle)
            .padding()
    }
}

//Camera settings view
struct CameraSettingsView: View {
    var body: some View {
        Text("Camera Settings")
            .font(.largeTitle)
            .padding()
    }
}

//Database settings view
struct WildlifeDatabaseSettingsView: View {
    var body: some View {
        Text("Wildlife Databases Settings")
            .font(.largeTitle)
            .padding()
    }
}

//Main settings view
struct SettingsView: View {
    var body: some View {
        NavigationStack{
            VStack{
                
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
}

#Preview {
    SettingsView()
}
