import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

/// View for managing account settings, including user name and data deletion options.
struct AccountSettingsView: View {
    @State private var userName: String = "" // The user's name, editable in the UI.
    @State private var isLoadingName = true // Tracks whether the user's name is being fetched.
    @State private var showConfirmationDialog = false // Determines if the delete confirmation dialog is shown.
    @State private var isDeleting = false // Tracks whether data deletion is in progress.
    @State private var deletionError: String? // Stores any errors related to data deletion.
    @State private var nameError: String? // Stores any errors related to fetching or updating the user's name.

    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Account Settings")
                .font(.largeTitle)
                .padding()

            Spacer()

            // User Name Section
            if isLoadingName {
                ProgressView("Loading user name...") // Loading indicator while fetching user name.
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    Text("User Name:")
                        .font(.headline)

                    // Text field to enter the user's name.
                    TextField("Enter your name", text: $userName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .autocapitalization(.words)
                        .disableAutocorrection(true)

                    // Button to save the user's name to Firestore.
                    Button(action: updateUserName) {
                        Text("Save Name")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .alert("Error", isPresented: .constant(nameError != nil), actions: {
                    Button("OK") { nameError = nil }
                }, message: {
                    Text(nameError ?? "")
                })
            }

            Spacer()

            // Clear All Data Section
            if isDeleting {
                ProgressView("Deleting all data...") // Loading indicator during data deletion.
            } else {
                Button(action: {
                    showConfirmationDialog = true // Show confirmation dialog.
                }) {
                    Text("Clear All Data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding()
                .alert("Error", isPresented: .constant(deletionError != nil), actions: {
                    Button("OK") { deletionError = nil }
                }, message: {
                    Text(deletionError ?? "")
                })
                .confirmationDialog("Are you sure you want to delete all your data? This action cannot be undone.", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                    Button("Delete All Data", role: .destructive) {
                        clearAllData() // Trigger data deletion.
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }

            Spacer()
        }
        .padding()
        .onAppear(perform: fetchUserName) // Fetch user name when the view appears.
    }

    /// Fetch the user's name from Firestore.
    private func fetchUserName() {
        guard let uid = Auth.auth().currentUser?.uid else {
            nameError = "User not authenticated."
            isLoadingName = false
            return
        }

        let userRef = Firestore.firestore().collection("Users").document(uid)
        userRef.getDocument { document, error in
            if let error = error {
                nameError = "Error fetching user name: \(error.localizedDescription)"
            } else if let document = document, let name = document.data()?["name"] as? String {
                self.userName = name
            } else {
                self.userName = ""
            }
            isLoadingName = false
        }
    }

    /// Update the user's name in Firestore.
    private func updateUserName() {
        guard let uid = Auth.auth().currentUser?.uid else {
            nameError = "User not authenticated."
            return
        }

        let userRef = Firestore.firestore().collection("Users").document(uid)
        userRef.updateData(["name": userName]) { error in
            if let error = error {
                nameError = "Error updating user name: \(error.localizedDescription)"
            }
        }
    }

    /// Clear all data for the current user, including Firestore and Firebase Storage.
    private func clearAllData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            deletionError = "User not authenticated."
            return
        }

        isDeleting = true
        deletionError = nil

        let firestore = Firestore.firestore()
        let storage = Storage.storage(url: "gs://snapemall.firebasestorage.app") // Explicitly use the custom bucket.

        // Delete Firestore collection.
        let userCollection = firestore.collection(uid)
        userCollection.getDocuments { snapshot, error in
            if let error = error {
                deletionError = "Error fetching Firestore documents: \(error.localizedDescription)"
                isDeleting = false
                return
            }

            guard let documents = snapshot?.documents else {
                deletionError = "No Firestore documents found to delete."
                isDeleting = false
                return
            }

            let dispatchGroup = DispatchGroup()

            for document in documents {
                dispatchGroup.enter()
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting Firestore document \(document.documentID): \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                print("All Firestore documents deleted.")
                // Proceed to delete Firebase Storage folder.
                deleteStorageFolder(for: uid, storageRef: storage.reference())
            }
        }
    }

    /// Delete Firebase Storage folder for the current user.
    private func deleteStorageFolder(for uid: String, storageRef: StorageReference) {
        let userFolder = storageRef.child(uid)
        userFolder.listAll { result, error in
            if let error = error {
                deletionError = "Error listing Firebase Storage files: \(error.localizedDescription)"
                isDeleting = false
                return
            }

            guard let items = result?.items else {
                deletionError = "No Firebase Storage files found to delete."
                isDeleting = false
                return
            }

            let dispatchGroup = DispatchGroup()

            for item in items {
                dispatchGroup.enter()
                item.delete { error in
                    if let error = error {
                        print("Error deleting Firebase Storage file \(item.fullPath): \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                print("All Firebase Storage files deleted.")
                isDeleting = false
            }
        }
    }
}

#Preview {
    AccountSettingsView()
}
