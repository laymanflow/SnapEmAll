//
//  HomeView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 9/19/24.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Home Page")
                    .font(.system(size: 40, weight: .bold, design: .serif))  // bold font
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()  // content to the top
                
            }
            .navigationBarTitleDisplayMode(.inline)  // keeps the custom title on the top
            .navigationBarItems(
                trailing: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")  // Gear icon for settings
                        .imageScale(.large)
                        .foregroundColor(.gray)  
                }
            )
        }
    }
}

#Preview {
    HomeView()
}


