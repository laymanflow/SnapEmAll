import Foundation
import SwiftUI

struct LogAnimalView: View {
    @State private var searchInput: String = ""
    @State private var selectedAnimal: String? = nil
    @Environment(\.dismiss) var dismiss // Handles dismissing the view

    let capturedImage: UIImage
    @ObservedObject var viewModel: SnappidexViewModel
    @ObservedObject var galleryViewModel: GalleryViewModel
    var onComplete: (String) -> Void
    var dismissParent: (() -> Void)?

    @FocusState private var isSearchBarFocused: Bool // Add focus state

    var filteredAnimals: [String] {
        viewModel.animals.filter { searchInput.isEmpty || $0.lowercased().contains(searchInput.lowercased()) }
    }

    var body: some View {
        VStack {
            Text("Assign Animal")
                .font(.largeTitle)
                .padding()

            Image(uiImage: capturedImage)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(10)
                .padding()

            TextField("Search for an animal", text: $searchInput)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.horizontal)
                .focused($isSearchBarFocused) // Attach the focus state

            List(filteredAnimals, id: \.self) { animal in
                Button(action: {
                    selectedAnimal = animal
                }) {
                    Text(animal)
                        .foregroundColor(.primary)
                }
            }

            if let selectedAnimal = selectedAnimal {
                Button(action: {
                    onComplete(selectedAnimal)
                    dismiss() // Dismiss this view
                    dismissParent?()
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

            Spacer()
        }
        .onAppear {
            viewModel.loadAnimalsFromJSON()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchBarFocused = true // Automatically focus on appear
            }
        }
    }
}
