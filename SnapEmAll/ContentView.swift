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
        NavigationView {
            VStack {
                // Sign-in message
                Text("Sign In")
                    .font(.largeTitle)
                    .padding()
                
                // Username text box
                TextField("Username: ", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .autocapitalization(.none)
                
                // Password text box
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
                
                // Create Account Link
                NavigationLink(destination: CreateAccountView()) {
                    Text("Create Account")
                        .foregroundColor(.blue)
                        .padding()
                        .underline()
                }
                Spacer() // Moves content to top
            }
            .padding()
        }
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

struct CreateAccountView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var signInError: String? = nil
    @State private var isSignedIn: Bool = false
    @State private var accounts: [String: String] = [:]  // Dictionary to simulate account storage

    var body: some View {
        VStack {
            // Create Account message
            Text("Create Account")
                .font(.largeTitle)
                .padding()

            // Username text box
            TextField("Username: ", text: $username)
                .textFieldStyle(.roundedBorder)
                .padding()
                .autocapitalization(.none)

            // Password text box
            SecureField("Password: ", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding()

            // Confirm Password text box
            SecureField("Confirm Password: ", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
                .padding()

            // Create Account button
            Button(action: createAccount) {
                Text("Create Account")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }

            // Error or success messages
            if let error = signInError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            if isSignedIn {
                Text("Account created successfully. Welcome, \(username)!")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
    }

    // Function to create a new account
    func createAccount() {
        // Check for empty fields
        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            signInError = "All fields must be filled."
            isSignedIn = false
            return
        }

        // Check if passwords match
        if password != confirmPassword {
            signInError = "Passwords do not match."
            isSignedIn = false
            return
        }

        // Check if username already exists
        if accounts[username] != nil {
            signInError = "Username already exists. Please choose another."
            isSignedIn = false
            return
        }

        // Simulate account creation (This is where you'd store account in the database)
        accounts[username] = password
        isSignedIn = true
        signInError = nil
    }
}

#Preview {
    ContentView()
}
