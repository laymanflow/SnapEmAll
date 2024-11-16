import SwiftUI
import CoreLocation

class SnappidexViewModel: ObservableObject {
    @Published var animals: [String] = []
    @Published var searchInput: String = ""
    
    // Filtered list based on search input
    var searchedAnimals: [String] {
        if searchInput.isEmpty {
            return animals
        } else {
            return animals.filter { $0.lowercased().contains(searchInput.lowercased()) }
        }
    }
    
    // Load animals from the JSON file
    func loadAnimalsFromJSON() {
        guard let url = Bundle.main.url(forResource: "animals", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedAnimals = try JSONDecoder().decode([String].self, from: data)
            DispatchQueue.main.async {
                self.animals = decodedAnimals
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}


//
//  SnappidexViewModel.swift
//  SnapEmAll
//
//  Created by Ethan Petrie on 11/7/24.
//

