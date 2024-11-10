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
    
    // Function to fetch animals from the GBIF API based on user's location
    func loadAnimals(latitude: Double, longitude: Double) {
        fetchLocalAnimals(userLat: latitude, userLong: longitude) { [weak self] localAnimals in
            DispatchQueue.main.async {
                self?.animals = localAnimals.map { $0.sciName }
            }
        }
    }
    
    func loadAnimalsWithCommonNames(scientificNames: [String]) {
        var commonNames: [String] = []
        let group = DispatchGroup() // To wait for all async tasks
        
        for scientificName in scientificNames {
            group.enter()
            fetchCommonName(scientificName: scientificName) { commonName in
                if let commonName = commonName {
                    commonNames.append(commonName)
                } else {
                    commonNames.append(scientificName) // Fallback if common name isn't found
                }
                group.leave()
            }
        }
        
        // Update animals list once all common names are fetched
        group.notify(queue: .main) {
            self.animals = commonNames
        }
    }
}


//
//  SnappidexViewModel.swift
//  SnapEmAll
//
//  Created by Ethan Petrie on 11/7/24.
//

