//
//  AccessibilitySettingsView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 11/5/24.
//
import SwiftUI

struct AccessibilitySettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("textSize") private var textSize: Double = 16.0
    
    var body: some View {
        VStack {
            Text("Accessibility Settings")
                .font(.largeTitle)
                .padding()
            
            // Dark Mode toggle
            Toggle(isOn: $isDarkMode) {
                Text("Dark Mode")
                    .font(.headline)
            }
            .padding()
            
            // Text Size slider
            Text("Text Size")
                .font(.headline)
            Slider(value: $textSize, in: 12...30, step: 1)
                .padding()
            
            Text("Preview Text")
                .font(.system(size: CGFloat(textSize)))
                .padding()
        }
        .padding()
        Spacer()
    }
}


