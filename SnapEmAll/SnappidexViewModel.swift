import SwiftUI
import FirebaseStorage

/// ViewModel to manage the data and logic for the SnappidexView.
class SnappidexViewModel: ObservableObject {
    @Published var animals: [String] = [] // List of all animals loaded from Firebase.
    @Published var searchInput: String = "" // User's search input to filter the animals.

    /// Computes a filtered list of animals based on the search input.
    var searchedAnimals: [String] {
        if searchInput.isEmpty {
            // Return all animals if there is no search input.
            return animals
        } else {
            // Return only animals whose names contain the search input (case-insensitive).
            return animals.filter { $0.lowercased().contains(searchInput.lowercased()) }
        }
    }

    /// Fetches the animal data from a JSON file stored in Firebase Storage.
    func loadAnimalsFromJSON() {
        // Initialize Firebase Storage with the specific bucket URL.
        let storage = Storage.storage(url: "gs://snapemall.firebasestorage.app")
        let storageRef = storage.reference().child("animals.json") // Reference to the `animals.json` file.

        // Fetch the data with a size limit of 1MB.
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Print an error message if there is an issue fetching the data.
                print("Error fetching animals.json: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                // Handle the case where no data is returned.
                print("No data received from animals.json")
                return
            }

            do {
                // Attempt to decode the JSON data into a list of strings.
                let decodedAnimals = try JSONDecoder().decode([String].self, from: data)
                // Update the `animals` property on the main thread.
                DispatchQueue.main.async {
                    self.animals = decodedAnimals
                }
            } catch {
                // Print an error message if JSON decoding fails.
                print("Error decoding animals.json: \(error)")
            }
        }
    }
}
