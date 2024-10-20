import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var signInError: String? = nil
    @State private var isSignedIn: Bool = false
    @State private var isAdmin: Bool = false  // Track if the logged-in user is an admin
    
    var body: some View {
        NavigationView {
            if isSignedIn {
                HomeView(isSignedIn: $isSignedIn, isAdmin: $isAdmin, username: $username, password: $password)
            } else {
                VStack {
                    Text("Sign In")
                        .font(.largeTitle)
                        .padding()
                    
                    TextField("Username: ", text: $username)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .autocapitalization(.none)
                    
                    SecureField("Password: ", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
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
                    
                    if let error = signInError {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
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

    func signIn() {
        if username.isEmpty || password.isEmpty {
            signInError = "Please enter both username and password."
            isSignedIn = false
        } else if username == "admin" && password == "admin123" {
            isSignedIn = true
            isAdmin = true
            signInError = nil
        } else if username == "testUser" && password == "password123" {  
            isSignedIn = true
            isAdmin = false
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
