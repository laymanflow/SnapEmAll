import Foundation
import SwiftUI

struct LogAnimalView: View {
    @State private var searchInput: String = ""
    @State private var selectedAnimal: String? = nil
    @Environment(\.dismiss) var dismiss

    let capturedImage: UIImage
    @ObservedObject var viewModel: SnappidexViewModel
    @ObservedObject var galleryViewModel: GalleryViewModel
    var onComplete: (String) -> Void

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
                    dismiss()
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
        }
    }
}


//
//  LogAnimalView.swift
//  SnapEmAll
//
//  Created by Ethan Petrie on 11/15/24.
//
