//
//  ContentView.swift
//  SnapEmAll
//
//  Created by Ethan Petrie on 9/18/24.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = "";
    @State private var password: String = "";
    
    var body: some View{
        VStack {
            //Sign in message
            Text("Sign In")
                .font(.largeTitle)
                .padding()
            
            //Username text box
            TextField("Username: ", text: $username)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            //Password text box
            TextField("Password: ", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
