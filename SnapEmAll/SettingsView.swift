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

struct SettingsView: View {
    var body: some View {
        VStack{
            
            Text("Settings")
                .font(.largeTitle)
                .padding()
            
            Button("Account"){
                print("Clicked")
            }
            .buttonStyle(SettingsButton())
            
            Button("Accessibility"){
                print("Clicked")
            }
            .buttonStyle(SettingsButton())
            
            Button("Notifications"){
                print("Clicked")
            }
            .buttonStyle(SettingsButton())
            
            Button("Camera"){
                print("Clicked")
            }
            .buttonStyle(SettingsButton())
            
            Button("Wildlife Databases"){
                print("Clicked")
            }
            .buttonStyle(SettingsButton())
        }
        
        .padding()
        Spacer()
    }
}

#Preview {
    SettingsView()
}
