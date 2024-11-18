import SwiftUI
import FirebaseStorage

// A view that allows admins to edit the list of animals stored in Firebase Storage.
struct EditAnimalsView: View {
    @State private var animals: [String] = [] // Holds the list of animal names.
    @State private var isLoading = true // Indicates if the data is still loading.
    @State private var errorMessage: String? = nil // Holds error messages for display.

    private let bucketURL = "gs://snapemall.firebasestorage.app" // Firebase Storage bucket URL.
    private let fileName = "animals.json" // The filename in Firebase Storage that holds the animal data.

    var body: some View {
        VStack {
            // Show a loading indicator while animals are being fetched.
            if isLoading {
                ProgressView("Loading animals...")
            }
            // Show an error message if loading fails.
            else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            // Display the list of animals for editing.
            else {
                List {
                    ForEach(animals, id: \.self) { animal in
                        HStack {
                            Text(animal)
                                .foregroundColor(.primary) // Display the animal name.
                            Spacer()
                            // Delete button to remove an animal from the list.
                            Button(action: {
                                deleteAnimal(animal)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            loadAnimals() // Load the list of animals when the view appears.
        }
        .navigationTitle("Edit Animals") // Title for the navigation bar.
        .toolbar {
            // Add a "Save" button in the toolbar to upload changes to Firebase Storage.
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    uploadAnimalsToStorage()
                }
            }
        }
    }

    /// Fetch the list of animals from Firebase Storage.
    private func loadAnimals() {
        let storage = Storage.storage(url: bucketURL) // Create a reference to Firebase Storage.
        let storageRef = storage.reference().child(fileName) // Reference the `animals.json` file.

        isLoading = true
        errorMessage = nil

        // Retrieve the file data with a maximum size of 1MB.
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            isLoading = false

            if let error = error {
                // Handle errors while fetching the file.
                print("Error fetching animals.json: \(error.localizedDescription)")
                errorMessage = "Failed to load animals."
                return
            }

            guard let data = data else {
                errorMessage = "No data received from Firebase."
                return
            }

            do {
                // Decode the JSON data into a list of animal names.
                let decodedAnimals = try JSONDecoder().decode([String].self, from: data)
                animals = decodedAnimals
            } catch {
                // Handle errors while decoding the JSON data.
                print("Error decoding animals.json: \(error)")
                errorMessage = "Failed to parse animal data."
            }
        }
    }

    /// Remove an animal from the local list.
    /// - Parameter animal: The name of the animal to remove.
    private func deleteAnimal(_ animal: String) {
        animals.removeAll { $0 == animal }
    }

    /// Upload the updated list of animals to Firebase Storage.
    private func uploadAnimalsToStorage() {
        let storage = Storage.storage(url: bucketURL) // Reference to Firebase Storage.
        let storageRef = storage.reference().child(fileName) // Reference the `animals.json` file.

        do {
            // Encode the list of animals into JSON data.
            let jsonData = try JSONEncoder().encode(animals)
            // Upload the data to Firebase Storage.
            storageRef.putData(jsonData, metadata: nil) { metadata, error in
                if let error = error {
                    // Handle errors while uploading the data.
                    print("Error uploading updated animals.json: \(error.localizedDescription)")
                    errorMessage = "Failed to save changes."
                    return
                }

                print("Updated animals.json successfully uploaded.")
            }
        } catch {
            // Handle errors while encoding the JSON data.
            print("Error encoding animals.json: \(error)")
            errorMessage = "Failed to encode animal data."
        }
    }
}
