import SwiftUI

struct SnappidexView: View {
    
    @StateObject private var viewModel = SnappidexViewModel()
    @State private var searchInput = ""
    @State private var selectedSegment = "Discovered";
    @Environment(\.dismiss) var dismiss
    
    let animals = [
        "White-tailed Deer",
        "Eastern Gray Squirrel",
        "Red Fox",
        "American Black Bear",
        "Eastern Chipmunk",
        "Snowshoe Hare",
        "American Beaver",
        "Bald Eagle",
        "Wild Turkey",
        "Eastern Box Turtle"
    ]
    
    let scientificNames = ["Odocoileus virginianus", "Sciurus carolinensis"] //Examples
    
    let discoveredAnimals: [String]
    
    init(discoveredAnimals: [String] = []) { // Provide a default empty array
        self.discoveredAnimals = discoveredAnimals
    }
    
    // Filter search results based on user input
    var filteredAnimals: [String] {
        let currentList = selectedSegment == "Discovered" ? discoveredAnimals : animals.filter { !discoveredAnimals.contains($0) }
        return searchInput.isEmpty ? currentList : currentList.filter { $0.lowercased().contains(searchInput.lowercased()) }
    }
    
    var body: some View {
        VStack {
            Text("Snappidex")
                .font(.largeTitle)
                .padding()
            
            Spacer()
                        
            Button(action: {
                dismiss() // Dismiss the Snappidex view and return to the map
            }) {
                Text("Return to Map")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
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
        .navigationBarTitle("Snappidex", displayMode: .inline)
        .onAppear {
            // Example coordinates; replace these with actual user coordinates
            let userLatitude = 40.0
            let userLongitude = -74.0
            viewModel.loadAnimals(latitude: userLatitude, longitude: userLongitude)
            viewModel.loadAnimalsWithCommonNames(scientificNames: scientificNames)
        }
    }
}


#Preview {
    SnappidexView(discoveredAnimals: ["Snowshoe Hare", "Bald Eagle"])
}


