//
//  ContentView.swift
//  SnapEmAll
//
//  Created by Ethan Petrie on 9/18/24.
//
import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var signInError: String? = nil
    @State private var isSignedIn: Bool = false
    
    var body: some View {
        VStack {
            // Sign in message
            Text("Sign In")
                .font(.largeTitle)
                .padding()
            
            //Username text box
            TextField("Username: ", text: $username)
                .textFieldStyle(.roundedBorder)
                .padding()
                .autocapitalization(.none)  // Ensures the username isn't auto-capitalized
            
            //Password text box
            SecureField("Password: ", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            // Sign-In button
            Button(action: signIn) {
                Text("Sign In")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
            
            // Error message if sign-in fails
            if let error = signInError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Feedback for successful sign-in
            if isSignedIn {
                Text("Welcome, \(username)!")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
    }

    // Sign-in function
    func signIn() {
        if username.isEmpty || password.isEmpty {
            signInError = "Please enter both username and password."
            isSignedIn = false
        } else if username == "testUser" && password == "password123" { // Example credentials for now
            isSignedIn = true
            signInError = nil
        } else {
            signInError = "Incorrect username or password."
            isSignedIn = false
        }
    }
}

#Preview {
    ContentView()
}
