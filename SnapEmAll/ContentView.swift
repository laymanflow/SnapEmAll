import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    // State variables to manage user input and authentication state
    @State private var phoneNumber: String = ""        // User's phone number input
    @State private var verificationCode: String = ""   // Verification code input
    @State private var verificationID: String? = nil   // Firebase verification ID
    @State private var signInError: String? = nil      // Error message to display to the user
    @State private var isSignedIn: Bool = false        // Tracks whether the user is signed in
    @State private var isAdmin: Bool = false           // Tracks whether the user has admin privileges
    @State private var isEnteringCode: Bool = false    // Tracks whether the user is entering a verification code

    var body: some View {
        NavigationView {
            if isSignedIn {
                // Show HomeView if the user is signed in
                HomeView(
                    isSignedIn: $isSignedIn,
                    isAdmin: $isAdmin,
                    username: $phoneNumber,
                    password: .constant(""),
                    resetLoginState: resetLoginState
                )
            } else {
                // Sign-in page layout
                VStack(spacing: 20) {
                    Text("Phone Number Sign In")
                        .font(.title)
                        .padding(.top, 50) // Ensure title has spacing from the top

                    // Display user's phone number or verification code
                    Text(isEnteringCode ? verificationCode : phoneNumber)
                        .font(.title)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.gray.opacity(0.2)) // Grey background for the text
                        .cornerRadius(10)

                    // Custom numeric keypad for input
                    KeypadView(onKeyPress: handleKeyPress)

                    // Buttons to send or verify the code
                    if verificationID != nil {
                        VStack(spacing: 10) {
                            // Verify the code
                            Button(action: verifyCode) {
                                Text("Verify Code")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)

                            // Restart login process
                            Button(action: resetLoginState) {
                                Text("Restart")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        // Send verification code
                        Button(action: sendCode) {
                            Text("Send Code")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }

                    // Error message placeholder
                    Text(signInError ?? " ")
                        .foregroundColor(.red)
                        .font(.body)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .background(Color(.systemGray6)) // Light grey background for error box

                    Spacer()
                }
                .padding()
                .onAppear {
                    // Dismiss the keyboard when the view appears
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
    }

    // Resets the login state to allow a fresh start
    func resetLoginState() {
        phoneNumber = ""
        verificationCode = ""
        verificationID = nil
        signInError = nil
        isEnteringCode = false
    }

    // Handles key presses on the custom keypad
    func handleKeyPress(key: String) {
        if isEnteringCode {
            // Handle backspace or appending to the verification code
            if key == "⌫" {
                if !verificationCode.isEmpty {
                    verificationCode.removeLast()
                }
            } else if verificationCode.count < 6 {
                verificationCode.append(key)
            }
        } else {
            // Handle backspace or appending to the phone number
            if key == "⌫" {
                if !phoneNumber.isEmpty {
                    phoneNumber.removeLast()
                }
            } else if phoneNumber.count < 15 {
                phoneNumber.append(key)
            }
        }
    }

    // Sends a verification code to the provided phone number
    func sendCode() {
        guard !phoneNumber.isEmpty else {
            signInError = "Please enter your phone number."
            return
        }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error as NSError? {
                self.signInError = error.localizedDescription
                return
            }
            self.verificationID = verificationID
            self.signInError = nil
            self.isEnteringCode = true
        }
    }

    // Verifies the code entered by the user and logs them in
    func verifyCode() {
        guard let verificationID = verificationID else {
            signInError = "No verification ID found. Please request a new code."
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error as NSError? {
                self.signInError = error.localizedDescription
                return
            }
            
            guard let uid = authResult?.user.uid else {
                self.signInError = "Unable to retrieve user ID."
                return
            }

            // Check if the user has admin privileges
            checkAdminPrivileges(for: uid)
        }
    }

    // Checks whether the logged-in user has admin privileges in Firestore
    func checkAdminPrivileges(for uid: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(uid)

        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                self.signInError = "Failed to fetch user data."
                return
            }

            if let document = document, document.exists {
                // Check the "hasPrivilege" field in Firestore
                if let hasPrivilege = document.data()?["hasPrivilege"] as? Bool {
                    self.isAdmin = hasPrivilege
                } else {
                    self.isAdmin = false
                }
            } else {
                // Create a new user document if it doesn't exist
                userRef.setData([
                    "hasPrivilege": false,
                    "name": "" // Default empty string for the name field
                ]) { error in
                    if let error = error {
                        print("Error creating user document: \(error.localizedDescription)")
                        self.signInError = "Failed to initialize user data."
                        return
                    }
                    self.isAdmin = false
                }
            }

            self.isSignedIn = true
            self.signInError = nil
        }
    }
}

// KeypadView struct: Provides a custom numeric keypad for input
struct KeypadView: View {
    var onKeyPress: (String) -> Void

    let keys = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["+", "0", "⌫"]
    ]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(keys, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { key in
                        Button(action: {
                            onKeyPress(key)
                        }) {
                            Text(key)
                                .font(.title)
                                .frame(width: 80, height: 80)
                                .foregroundColor(.blue)  // Text color
                                .background(Color.clear) // Transparent background
                                .cornerRadius(40)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
