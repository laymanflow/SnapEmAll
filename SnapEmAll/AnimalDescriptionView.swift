import SwiftUI

//cache to hold the data fetched from wikipedia so a fetch is not necessary every time
class AnimalCache {
    static var shared = AnimalCache()
    var descriptionCache: [String: String] = [:]  //caches descriptions
    var imageCache: [String: String] = [:]        //caches images
}

struct AnimalDescriptionView: View {
    let animalName: String
    @State private var description: String = "Loading..."
    @State private var imageUrl: String?
    @State private var scientificName: String = "Loading..."
    
    var body: some View {
        VStack {
            //Animal name (title)
            Text(animalName)
                .font(.largeTitle)
                .padding()
            
            //Animal scientific name
            Text(scientificName)
                .font(.title)
                .padding()
            
            //displays an image of the animal fetched from wikipedia
            if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                        .padding()
                } placeholder: {
                    ProgressView()
                        .padding()
                }
            }
            
            Text(description)
                .font(.body)
                .padding()
            
            Spacer()
        }
        .onAppear {
            loadFromAnimalCache(animal: animalName)
        }
    }
    
    //checks if requested animal data is already in the cache, fetch if not
    func loadFromAnimalCache(animal: String) {
        if let cachedDescription = AnimalCache.shared.descriptionCache[animal],
            let cachedImageUrl = AnimalCache.shared.imageCache[animal] {
            // Use cached data
            print("Loading \(animal) from cache.")
            description = cachedDescription
            imageUrl = cachedImageUrl
        } 
        else{
            //fetch the data if it's not already in the cache
            print("Fetching \(animal) from wikipedia.")
            fetchAnimalDescription(animal: animal)
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
                       let extract = json["extract"] as? String,
                       let thumbnail = json["thumbnail"] as? [String: Any],
                       let imageSource = thumbnail["source"] as? String{
                        
                        let scientificName = json["binomial name"] as? String ?? "N/A"
                        
                        DispatchQueue.main.async {
                            
                            self.scientificName = scientificName;
                            
                            
                            description = extract
                            imageUrl = imageSource
                            
                            //cache for future use
                            AnimalCache.shared.descriptionCache[animal] = extract
                            AnimalCache.shared.imageCache[animal] = imageSource
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

