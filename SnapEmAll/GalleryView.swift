import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct GalleryItem: Identifiable {
    let id = UUID()
    let image: UIImage
    let animalName: String
    let description: String?
}

struct GalleryView: View {
    @State private var galleryItems: [GalleryItem] = []
    @State private var selectedGalleryItem: GalleryItem?
    @State private var isLoading: Bool = true
    @State private var loadError: String?
    @ObservedObject var galleryViewModel: GalleryViewModel

    var discoveredAnimalNames: [String] {
        galleryItems.map { $0.animalName }
    }

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                } else if let error = loadError {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(), GridItem()]) {
                            ForEach(galleryItems) { item in
                                VStack {
                                    Image(uiImage: item.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            selectedGalleryItem = item
                                        }
                                    Text(item.animalName)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                fetchGalleryDataForUser()
            }
            .sheet(item: $selectedGalleryItem) { item in
                GalleryPhotoView(galleryItem: item)
            }
            .navigationTitle("Gallery")
            .navigationBarItems(trailing: NavigationLink("Go to Snappidex") {
                SnappidexView(discoveredAnimals: discoveredAnimalNames)
            })
        }
    }

    /// Fetch data from Firestore for the logged-in user
    func fetchGalleryDataForUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            loadError = "User not logged in."
            isLoading = false
            return
        }

        let db = Firestore.firestore()
        let userGalleryPath = "\(uid)"
        isLoading = true
        loadError = nil

        db.collection(userGalleryPath).getDocuments { snapshot, error in
            isLoading = false

            if let error = error {
                print("Error fetching user-specific gallery data: \(error.localizedDescription)")
                loadError = error.localizedDescription
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found in the user's gallery.")
                loadError = "No data found."
                return
            }

            var fetchedItems: [GalleryItem] = []

            for document in documents {
                let data = document.data()
                guard
                    let base64String = data["imageData"] as? String,
                    let animalName = data["animalName"] as? String,
                    let imageData = Data(base64Encoded: base64String),
                    let image = UIImage(data: imageData)
                else {
                    print("Skipping invalid document: \(document.documentID)")
                    continue
                }

                let description = data["description"] as? String
                let galleryItem = GalleryItem(image: image, animalName: animalName, description: description)
                fetchedItems.append(galleryItem)
            }

            self.galleryItems = fetchedItems
            if galleryItems.isEmpty {
                loadError = "No valid items found."
            }
        }
    }
}
