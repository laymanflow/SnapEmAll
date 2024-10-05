import SwiftUI

struct AnimalDescriptionView: View {
    let animalName: String
    @State private var description: String = "Loading..."
    
    var body: some View {
        VStack {
            Text(animalName)
                .font(.largeTitle)
                .padding()
            
            Text(description)
                .font(.body)
                .padding()
            
            Spacer()
        }
        .onAppear {
            fetchAnimalDescription(animal: animalName)
        }
    }
    
    // Fetch animal description from Wikipedia
    func fetchAnimalDescription(animal: String) {
        // Encode animal name for URL
        let encodedAnimal = animal.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? animal
        
        // Create Wikipedia API URL
        if let url = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(encodedAnimal)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    // Try to parse JSON data
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let extract = json["extract"] as? String {
                        DispatchQueue.main.async {
                            description = extract
                        }
                    } else {
                        DispatchQueue.main.async {
                            description = "Description not found."
                        }
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        description = "Error: \(error.localizedDescription)"
                    }
                }
            }
            task.resume()
        } else {
            description = "Invalid URL."
        }
    }
}

#Preview {
    AnimalDescriptionView(animalName: "Bald Eagle")
}
//
//  AnimalDescriptionView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 10/5/24.
//

