//
//  CameraSettingsView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 11/5/24.
//
import SwiftUI

struct CameraSettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Camera Settings")
                .font(.largeTitle)
                .padding()

            Text("Manage camera access for SnapEmAll.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Button(action: openCameraSettings) {
                Text("Open Camera Settings")
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

    // Function to open Camera Settings
    func openCameraSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    CameraSettingsView()
}
