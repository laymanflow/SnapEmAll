import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

/// A view to display a single photo in the gallery with options to log or describe the associated animal.
struct GalleryPhotoView: View {
    @State private var isLogAnimalViewPresented = false // Tracks whether the LogAnimalView is being presented.
    @State private var isAnimalDescriptionViewPresented = false // Tracks whether the AnimalDescriptionView is being presented.
    let galleryItem: GalleryItem // The gallery item to display, containing image, animal name, and metadata.
    @ObservedObject var galleryViewModel: GalleryViewModel // Observed view model for managing the gallery's state.
    let uid: String? // Optional UID, provided when viewing another user's gallery (for admin purposes).

    var body: some View {
        VStack {
            // If the animal's name is "Unknown Animal," allow the user to log the animal.
            if galleryItem.animalName == "Unknown Animal" {
                Button("Log Animal") {
                    isLogAnimalViewPresented = true // Show the LogAnimalView when the button is tapped.
                }
                .sheet(isPresented: $isLogAnimalViewPresented) {
                    LogAnimalView(
                        capturedImage: galleryItem.image,
                        viewModel: SnappidexViewModel(), // ViewModel for managing the Snappidex (animal database).
                        galleryViewModel: galleryViewModel
                    ) { selectedAnimal in
                        // Handle the completion of logging the animal.
                        updateAnimalNameInFirestore(selectedAnimal)
                        if let index = galleryViewModel.galleryItems.firstIndex(where: { $0.id == galleryItem.id }) {
                            galleryViewModel.galleryItems[index].animalName = selectedAnimal
                        }
                    }
                }
            } else {
                // Display the animal's name as a tappable text if it has already been identified.
                Text(galleryItem.animalName)
                    .font(.title)
                    .padding()
                    .onTapGesture {
                        isAnimalDescriptionViewPresented = true // Show the AnimalDescriptionView when tapped.
                    }
                    .sheet(isPresented: $isAnimalDescriptionViewPresented) {
                        AnimalDescriptionView(animalName: galleryItem.animalName) // Show animal details.
                    }
            }

            // Display the image associated with the gallery item.
            Image(uiImage: galleryItem.image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Spacer()
        }
    }

    /// Updates the animal name in Firestore for the given gallery item.
    private func updateAnimalNameInFirestore(_ animalName: String) {
        let db = Firestore.firestore()

        // Determine the correct UID (either provided by admin or authenticated user).
        let resolvedUID: String
        if let providedUID = uid, providedUID.count > 5 {
            resolvedUID = providedUID
            print("Using provided UID: \(resolvedUID)")
        } else if let authUID = Auth.auth().currentUser?.uid, authUID.count > 5 {
            resolvedUID = authUID
            print("Using authenticated user's UID: \(resolvedUID)")
        } else {
            print("Error: No valid UID found or UID too short.")
            return
        }

        // Construct the document path in Firestore.
        let documentPath = "\(resolvedUID)/\(galleryItem.documentID)"
        print("Document path resolved to: \(documentPath)")

        // Perform the update operation in Firestore.
        db.document(documentPath).updateData(["animalName": animalName]) { error in
            if let error = error {
                print("Error updating animal name in Firestore: \(error.localizedDescription)")
            } else {
                print("Successfully updated animal name in Firestore for document: \(documentPath)")
            }
        }
    }
}
