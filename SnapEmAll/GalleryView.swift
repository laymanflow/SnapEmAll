import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

// Represents a single gallery item with its associated image, name, description, and Firestore document ID.
struct GalleryItem: Identifiable {
    let id = UUID() // Unique identifier for SwiftUI lists.
    let image: UIImage // The image displayed in the gallery.
    var animalName: String // The name of the animal in the image.
    let description: String? // Optional description of the image.
    let documentID: String // Firestore document ID for the item, used for updates or deletion.
}

// The main view for displaying the gallery of images.
struct GalleryView: View {
    @State private var selectedGalleryItem: GalleryItem? // Tracks the currently selected gallery item for detail view.
    @ObservedObject var galleryViewModel: GalleryViewModel // ViewModel managing gallery state and data.
    @State private var isLoading: Bool = true // Indicates whether data is still being loaded.
    @State private var loadError: String? // Holds any error messages related to data loading.
    var uid: String? // Optional UID for fetching a specific user's gallery (useful for admin views).

    // Returns a list of all discovered animal names in the gallery.
    var discoveredAnimalNames: [String] {
        galleryViewModel.galleryItems.map { $0.animalName }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Display a loading indicator while data is being fetched.
                if isLoading {
                    ProgressView("Loading...")
                }
                // Show an error message if data loading fails.
                else if let error = loadError {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                // Display the gallery items if data is successfully loaded.
                else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(), GridItem()]) { // A grid layout for the gallery.
                            ForEach(galleryViewModel.galleryItems) { item in
                                VStack {
                                    Image(uiImage: item.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            selectedGalleryItem = item // Select the item for detailed view.
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                fetchGalleryData(for: uid) // Fetch data when the view appears.
            }
            .sheet(item: $selectedGalleryItem) { item in
                // Present a detailed view of the selected gallery item.
                GalleryPhotoView(
                    galleryItem: item,
                    galleryViewModel: galleryViewModel,
                    uid: uid ?? "" // Pass the user ID to the detail view.
                )
            }
            .navigationTitle("Gallery") // Set the title of the navigation bar.
            .navigationBarItems(trailing: NavigationLink("Go to Snappidex") {
                SnappidexView(discoveredAnimals: discoveredAnimalNames) // Navigate to the Snappidex.
            })
        }
    }

    // Fetches the gallery data for the current user or a specified user (admin use).
    private func fetchGalleryData(for uid: String?) {
        guard let userId = uid ?? Auth.auth().currentUser?.uid else {
            // Set an error message if no user ID is available.
            loadError = "User ID not found."
            isLoading = false
            return
        }

        let db = Firestore.firestore() // Firestore instance.
        let storage = Storage.storage(url: "gs://snapemall.firebasestorage.app") // Firebase Storage instance.
        let userGalleryPath = "\(userId)" // Collection path based on user ID.
        isLoading = true
        loadError = nil

        // Fetch all documents from the user's gallery collection.
        db.collection(userGalleryPath).getDocuments { snapshot, error in
            isLoading = false // Stop loading indicator.

            if let error = error {
                // Set an error message if the Firestore query fails.
                print("Error fetching user-specific gallery data: \(error.localizedDescription)")
                loadError = error.localizedDescription
                return
            }

            guard let documents = snapshot?.documents else {
                // Handle the case where no documents are found.
                print("No documents found in the user's gallery.")
                loadError = "No data found."
                return
            }

            var fetchedItems: [GalleryItem] = [] // Temporary list to hold gallery items.
            let dispatchGroup = DispatchGroup() // Group to synchronize asynchronous tasks.

            for document in documents {
                let data = document.data() // Extract data from the Firestore document.
                guard
                    let imagePath = data["imagePath"] as? String, // Image storage path.
                    let animalName = data["animalName"] as? String // Animal name.
                else {
                    print("Skipping invalid document: \(document.documentID)")
                    continue
                }

                let description = data["description"] as? String // Optional description.
                let documentID = document.documentID // Firestore document ID.

                dispatchGroup.enter() // Track an asynchronous task.
                let storageRef = storage.reference(withPath: imagePath) // Reference to the image in Firebase Storage.

                // Fetch the image data from Firebase Storage.
                storageRef.getData(maxSize: 10 * 1024 * 1024) { imageData, error in
                    defer { dispatchGroup.leave() } // Mark the task as complete.

                    if let imageData = imageData, let image = UIImage(data: imageData) {
                        // Create a new GalleryItem and add it to the list.
                        let galleryItem = GalleryItem(image: image, animalName: animalName, description: description, documentID: documentID)
                        fetchedItems.append(galleryItem)
                    }
                }
            }

            // Once all tasks are complete, update the gallery view model.
            dispatchGroup.notify(queue: .main) {
                galleryViewModel.galleryItems = fetchedItems
                if galleryViewModel.galleryItems.isEmpty {
                    loadError = "No valid items found."
                }
            }
        }
    }
}
