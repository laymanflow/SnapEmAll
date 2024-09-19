//
//  CreateAccountView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 9/19/24.
//
import SwiftUI

struct CreateAccountView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var signInError: String? = nil
    @State private var accounts: [String: String] = [:]
    var signInCallback: () -> Void  // Callback to notify successful sign in

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
        }
        .padding()
    }

    // Function to create a new account
    func createAccount() {
        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            signInError = "All fields must be filled."
            return
        }

        if password != confirmPassword {
            signInError = "Passwords do not match."
            return
        }

        if accounts[username] != nil {
            signInError = "Username already exists."
            return
        }

        accounts[username] = password
        signInError = nil
        
        signInCallback()
    }
}

#Preview {
    CreateAccountView(signInCallback: {})
}

