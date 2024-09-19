import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var signInError: String? = nil
    @State private var isSignedIn: Bool = false  // This state is used to track sign-in status
    
    var body: some View {
        NavigationView {
            if isSignedIn {
                // Pass the isSignedIn, username, and password state to HomeView
                HomeView(isSignedIn: $isSignedIn, username: $username, password: $password)
            } else {
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
                    
                    // Create Account Link
                    NavigationLink(destination: CreateAccountView(signInCallback: {
                        self.isSignedIn = true
                    })) {
                        Text("Create Account")
                            .foregroundColor(.blue)
                            .padding()
                            .underline()
                    }
                    
                    Spacer()
                }
                .padding()
            }
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

#Preview {
    ContentView()
}
