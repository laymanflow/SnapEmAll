import Foundation
import SwiftUI

// LogAnimalView: A view that allows the user to assign an animal to a captured image.
struct LogAnimalView: View {
    @State private var searchInput: String = "" // State variable to track search input.
    @State private var selectedAnimal: String? = nil // State variable for the selected animal.
    @Environment(\.dismiss) var dismiss // Environment property to handle dismissing the view.

    let capturedImage: UIImage // The captured image being logged.
    @ObservedObject var viewModel: SnappidexViewModel // ViewModel for managing the animal list.
    @ObservedObject var galleryViewModel: GalleryViewModel // ViewModel for managing the gallery.
    var onComplete: (String) -> Void // Callback when an animal is assigned.
    var dismissParent: (() -> Void)? // Optional callback to dismiss the parent view.

    @FocusState private var isSearchBarFocused: Bool // Focus state to control keyboard visibility.

    // Computed property to filter animals based on the search input.
    var filteredAnimals: [String] {
        viewModel.animals.filter { searchInput.isEmpty || $0.lowercased().contains(searchInput.lowercased()) }
    }

    var body: some View {
        VStack {
            // Title of the view
            Text("Assign Animal")
                .font(.largeTitle)
                .padding()

            // Display the captured image
            Image(uiImage: capturedImage)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(10)
                .padding()

            // Search bar for filtering animal names
            TextField("Search for an animal", text: $searchInput)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.horizontal)
                .focused($isSearchBarFocused) // Focus on the search bar automatically.

            // List of filtered animals
            List(filteredAnimals, id: \.self) { animal in
                Button(action: {
                    selectedAnimal = animal // Set the selected animal when clicked.
                }) {
                    Text(animal)
                        .foregroundColor(.primary)
                }
            }

            // Button to confirm the selection if an animal is chosen.
            if let selectedAnimal = selectedAnimal {
                Button(action: {
                    onComplete(selectedAnimal) // Call the completion handler with the selected animal.
                    dismiss() // Dismiss this view.
                    dismissParent?() // Dismiss the parent view if the callback is provided.
                }) {
                    Text("Assign \(selectedAnimal)")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }

            Spacer() // Pushes content to the top of the view.
        }
        .onAppear {
            viewModel.loadAnimalsFromJSON() // Load animal data from a JSON file when the view appears.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchBarFocused = true // Automatically focus on the search bar after a short delay.
            }
        }
    }
}
