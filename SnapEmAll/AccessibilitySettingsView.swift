//
//  AccessibilitySettingsView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 11/5/24.
//
import SwiftUI

/// A view that allows users to adjust accessibility settings, including Dark Mode and text size.
struct AccessibilitySettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false // Stores the Dark Mode toggle state in app settings.
    @AppStorage("textSize") private var textSize: Double = 16.0 // Stores the text size value in app settings.

    var body: some View {
        VStack {
            // Title
            Text("Accessibility Settings")
                .font(.largeTitle)
                .padding()

            // Toggle for enabling/disabling Dark Mode.
            Toggle(isOn: $isDarkMode) {
                Text("Dark Mode")
                    .font(.headline)
            }
            .padding()

            // Slider for adjusting the text size.
            Text("Text Size")
                .font(.headline)
            Slider(value: $textSize, in: 12...30, step: 1) // Allows users to set text size between 12 and 30 points.
                .padding()

            // Preview area to demonstrate the selected text size.
            Text("Preview Text")
                .font(.system(size: CGFloat(textSize))) // Dynamically adjusts the font size based on the slider value.
                .padding()
        }
        .padding() // Adds padding around the view.
        Spacer() // Pushes content upward to avoid crowding.
    }
}
