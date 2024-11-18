import SwiftUI

struct SnappidexView: View {
    
    @StateObject private var viewModel = SnappidexViewModel() // Observes and manages data for the Snappidex.
    @State private var selectedSegment = "Discovered" // Tracks whether the user is viewing discovered or undiscovered animals.
    @Environment(\.dismiss) var dismiss // Environment property to allow dismissing the view.
    
    let discoveredAnimals: [String] // List of animals the user has already discovered.
    
    /// Filters the list of animals based on the current segment (discovered/undiscovered) and search input.
    var filteredAnimals: [String] {
        // Determine the list based on the selected segment.
        let currentList = selectedSegment == "Discovered" ? discoveredAnimals : viewModel.animals.filter { !discoveredAnimals.contains($0) }
        // Filter the list further based on the user's search input.
        return viewModel.searchInput.isEmpty ? currentList : currentList.filter { $0.lowercased().contains(viewModel.searchInput.lowercased()) }
    }
    
    /// Initializer to optionally provide a list of discovered animals.
    init(discoveredAnimals: [String] = []) { // Provide a default empty array if no data is passed.
        self.discoveredAnimals = discoveredAnimals
    }
        
    var body: some View {
        VStack {
            // Title of the Snappidex screen.
            Text("Snappidex")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            // Picker to toggle between discovered and undiscovered animals.
            Picker("Select", selection: $selectedSegment) {
                Text("Discovered").tag("Discovered") // Tag for discovered animals.
                Text("Undiscovered").tag("Undiscovered") // Tag for undiscovered animals.
            }
            .pickerStyle(SegmentedPickerStyle()) // Display the picker as a segmented control.
            .padding()
            
            Spacer()
            
            // Search bar to allow users to filter the animal list by name.
            TextField("Search for an animal", text: $viewModel.searchInput)
                .padding(8)
                .background(Color(.systemGray5)) // Light gray background for the search bar.
                .cornerRadius(10) // Rounded corners for the search bar.
                .padding(.horizontal)
            
            // List of filtered animals based on the search input and selected segment.
            List(filteredAnimals, id: \.self) { animal in
                NavigationLink(destination: AnimalDescriptionView(animalName: animal)) { // Navigates to the detailed description of the selected animal.
                    Text(animal)
                        .font(.headline)
                        .padding()
                }
            }
        }
        .onAppear {
            // Load the list of all animals from a JSON file when the view appears.
            viewModel.loadAnimalsFromJSON()
        }
    }
}

#Preview {
    // Preview of the SnappidexView with two discovered animals.
    SnappidexView(discoveredAnimals: ["Snowshoe Hare", "Bald Eagle"])
}
