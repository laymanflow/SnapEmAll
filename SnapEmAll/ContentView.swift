import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var verificationID: String? = nil
    @State private var signInError: String? = nil
    @State private var isSignedIn: Bool = false
    @State private var isAdmin: Bool = false  // Track if the logged-in user is an admin
    @State private var isEnteringCode: Bool = false
    
    var body: some View {
        NavigationView {
            if isSignedIn {
                HomeView(isSignedIn: $isSignedIn, isAdmin: $isAdmin, username: $phoneNumber, password: .constant(""))
            } else {
                VStack(spacing: 20) {
                    Text("Phone Number Sign In")
                        .font(.largeTitle)
                        .padding()

                    // Display phone number or verification code being entered
                    Text(isEnteringCode ? verificationCode : phoneNumber)
                        .font(.title)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)

                    // Display the keypad with numbers and backspace
                    KeypadView(onKeyPress: handleKeyPress)

                    // Action buttons for send/verify code
                    if verificationID != nil {
                        Button(action: verifyCode) {
                            Text("Verify Code")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    } else {
                        Button(action: sendCode) {
                            Text("Send Code")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }

                    if let error = signInError {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }

                    Spacer()

                    // Button to bypass login for testing
                    Button(action: {
                        self.isSignedIn = true  // Simulate successful sign-in
                        self.isAdmin = self.phoneNumber == "+1234567890"  // Example admin phone number logic
                    }) {
                        Text("Skip Sign-In for Testing")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .padding()
                .onAppear {
                    // Disable the keyboard globally
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
    }

    // Custom keypad input handler
    func handleKeyPress(key: String) {
        if isEnteringCode {
            if key == "⌫" {
                if !verificationCode.isEmpty {
                    verificationCode.removeLast()
                }
            } else if verificationCode.count < 6 {
                verificationCode.append(key)
            }
        } else {
            if key == "⌫" {
                if !phoneNumber.isEmpty {
                    phoneNumber.removeLast()
                }
            } else if phoneNumber.count < 15 {
                phoneNumber.append(key)
            }
        }
    }

    // Send the verification code to the entered phone number
    func sendCode() {
        guard !phoneNumber.isEmpty else {
            signInError = "Please enter your phone number."
            return
        }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                self.signInError = error.localizedDescription
                return
            }
            self.verificationID = verificationID
            self.signInError = nil
            self.isEnteringCode = true
        }
    }

    // Verify the entered code
    func verifyCode() {
        guard let verificationID = verificationID else {
            signInError = "No verification ID found. Please request a new code."
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                self.signInError = error.localizedDescription
                return
            }

            self.isAdmin = self.phoneNumber == "+1234567890"  // Example admin phone number
            self.isSignedIn = true
            self.signInError = nil
        }
    }
}

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
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(40)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
