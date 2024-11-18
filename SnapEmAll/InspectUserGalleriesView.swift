import SwiftUI
import FirebaseFirestore

/// A view to inspect galleries of different users by listing their names and UIDs.
struct InspectUserGalleriesView: View {
    @State private var users: [(uid: String, name: String)] = [] // Holds the list of users with their UIDs and names.
    @State private var isLoading = true // Indicates if the user data is being loaded.
    @State private var loadError: String? // Stores any error message encountered during data fetching.

    var body: some View {
        VStack {
            if isLoading {
                // Displays a loading indicator while fetching user data.
                ProgressView("Loading user galleries...")
            } else if let error = loadError {
                // Displays an error message if data fetching fails.
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                // Displays the list of users with their names and UIDs.
                List(users, id: \.uid) { user in
                    NavigationLink(
                        destination: GalleryView(
                            galleryViewModel: GalleryViewModel(),
                            uid: user.uid // Passes the user's UID to the `GalleryView`.
                        )
                    ) {
                        // Displays the user's name, or a placeholder if the name is empty.
                        Text(user.name.isEmpty ? "Unnamed User (\(user.uid))" : user.name)
                    }
                }
            }
        }
        .onAppear {
            fetchUsers() // Fetch user data when the view appears.
        }
        .navigationTitle("User Galleries") // Sets the navigation title for the view.
    }

    /// Fetches user data (UIDs and names) from the "Users" collection in Firestore.
    private func fetchUsers() {
        let db = Firestore.firestore() // Get a Firestore instance.
        isLoading = true // Set loading state to true while fetching data.
        loadError = nil // Reset any previous error message.

        db.collection("Users").getDocuments { snapshot, error in
            if let error = error {
                // Handle error by setting the error message and stopping loading.
                loadError = "Error fetching user galleries: \(error.localizedDescription)"
                isLoading = false
                return
            }

            guard let documents = snapshot?.documents else {
                // Handle case where no documents are found in the "Users" collection.
                loadError = "No user galleries found."
                isLoading = false
                return
            }

            // Map the documents to a list of tuples containing UIDs and names.
            users = documents.map { document in
                let uid = document.documentID // The document ID is the user's UID.
                let name = document.data()["name"] as? String ?? "" // Fetch the user's name, default to empty if not found.
                return (uid: uid, name: name)
            }

            if users.isEmpty {
                // If no users are found, set an appropriate error message.
                loadError = "No user galleries found."
            }
            isLoading = false // Stop loading once data is processed.
        }
    }
}
