import SwiftUI

struct SnappidexView: View {
    
    @StateObject private var viewModel = SnappidexViewModel()
    @State private var selectedSegment = "Discovered";
    @Environment(\.dismiss) var dismiss
    
    let discoveredAnimals: [String]
    
    // Filter search results based on user input
    var filteredAnimals: [String] {
        let currentList = selectedSegment == "Discovered" ? discoveredAnimals : viewModel.animals.filter { !discoveredAnimals.contains($0) }
        return viewModel.searchInput.isEmpty ? currentList : currentList.filter { $0.lowercased().contains(viewModel.searchInput.lowercased()) }
    }
    
    init(discoveredAnimals: [String] = []) { // Provide a default empty array
        self.discoveredAnimals = discoveredAnimals
    }
        
    var body: some View {
        VStack {
            Text("Snappidex")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            // Toggle button to swap between discovered and undiscovered animals
            Picker("Select", selection: $selectedSegment) {
                Text("Discovered").tag("Discovered")
                Text("Undiscovered").tag("Undiscovered")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Spacer()
            
            TextField("Search for an animal", text: $viewModel.searchInput)
                                .padding(8)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                                .padding(.horizontal)
            
            List(filteredAnimals, id: \.self) { animal in
                NavigationLink(destination: AnimalDescriptionView(animalName: animal)) {
                    Text(animal)
                        .font(.headline)
                        .padding()
                }
            }
        }
        .onAppear {
            viewModel.loadAnimalsFromJSON()
        }
    }
}


#Preview {
    SnappidexView(discoveredAnimals: ["Snowshoe Hare", "Bald Eagle"])
}


