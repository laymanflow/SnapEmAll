import SwiftUI

//cache to hold the data fetched from wikipedia so a fetch is not necessary every time
class AnimalCache {
    static var shared = AnimalCache()
    var descriptionCache: [String: String] = [:]  //caches descriptions
    var imageCache: [String: String] = [:]        //caches images
    var scientificNameCache: [String: String] = [:] //cache scientific names
    var countryCache: [String: String] = [:] //cache countries
}

struct AnimalDescriptionView: View {
    let animalName: String
    @State private var description: String = "Loading..."
    @State private var imageUrl: String?
    @State private var scientificName: String = "Loading..."
    @State private var country: String = "Loading..."
    
    var body: some View {
        VStack {
            //Animal name (title)
            Text(animalName)
                .font(.largeTitle)
                .padding()
            
            //scientific name
            Text("Scientific Name:")
                .font(.title2)
                .fontWeight(.semibold)
            Text(scientificName)
                .font(.title3)
                .italic()
                .foregroundColor(.gray)

            //country of origin
            Text("Country of origin:")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 10)
            Text(country)
                .font(.title3)
                .foregroundColor(.gray)
            
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
            let cachedImageUrl = AnimalCache.shared.imageCache[animal],
            let cachedScientificName = AnimalCache.shared.scientificNameCache[animal],
            let cachedCountry = AnimalCache.shared.countryCache[animal]{
            // Use cached data
            print("Loading \(animal) from cache.")
            description = cachedDescription
            imageUrl = cachedImageUrl
            scientificName = cachedScientificName
            country = cachedCountry
        }
        else{
            //fetch the data if it's not already in the cache
            print("Fetching \(animal) from wikipedia.")
            fetchAnimalDescription(animal: animal)
            fetchDataGBIF(animal: animal)
        }
    }
    
    //fetch data from GBI species API
    func fetchDataGBIF(animal: String) {
        //GBIF API species search endpoint
        let speciesUrlString = "https://api.gbif.org/v1/species/search?q=\(animal.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? animal)"
        
        guard let speciesUrl = URL(string: speciesUrlString) else {
            print("Invalid GBIF species URL")
            return
        }
        
        //first fetch: Get the scientific name
        let speciesTask = URLSession.shared.dataTask(with: speciesUrl) { data, response, error in
            if let error = error {
                print("Error fetching scientific name from GBIF: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned from GBIF API")
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let results = jsonResponse?["results"] as? [[String: Any]] {
                    //filter results to show only genus and species
                    if let correctResult = results.first(where: {
                        ($0["rank"] as? String == "SPECIES") && ($0["kingdom"] as? String == "Animalia")
                    }), let fetchedScientificName = correctResult["scientificName"] as? String {
                        
                        DispatchQueue.main.async {
                            self.scientificName = fetchedScientificName
                            AnimalCache.shared.scientificNameCache[animal] = fetchedScientificName
                        }
                        
                        //second fetch: country where species is found
                        self.fetchCountryGBIF(scientificName: fetchedScientificName, animal: animal)
                        
                    } 
                    else {
                        DispatchQueue.main.async {
                            self.scientificName = "Scientific name not found."
                        }
                    }
                } 
                else {
                    DispatchQueue.main.async {
                        self.scientificName = "Scientific name not found."
                    }
                }
            }
            catch {
                print("Failed to parse GBIF response: \(error)")
                DispatchQueue.main.async {
                    self.scientificName = "Error fetching scientific name."
                }
            }
        }
        
        speciesTask.resume()
    }
    
    //fetch the country from GBIF Occurences API
    func fetchCountryGBIF(scientificName: String, animal: String) {
        
        //GBIF API occurrence search endpoint
        let occurrenceUrlString = "https://api.gbif.org/v1/occurrence/search?scientificName=\(scientificName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? scientificName)&hasCoordinate=true"
        
        guard let occurrenceUrl = URL(string: occurrenceUrlString) else {
            print("Invalid GBIF occurrence URL")
            return
        }
        
        //fetch country for given species
        let occurrenceTask = URLSession.shared.dataTask(with: occurrenceUrl) { data, response, error in
            if let error = error {
                print("Error fetching country from GBIF: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned from GBIF occurrence API")
                return
            }
            
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let results = jsonResponse?["results"] as? [[String: Any]],
                   let firstResult = results.first,
                   let fetchedCountry = firstResult["country"] as? String {
                    
                    DispatchQueue.main.async {
                        self.country = fetchedCountry
                        AnimalCache.shared.countryCache[animal] = fetchedCountry
                    }
                    
                } 
                else {
                    DispatchQueue.main.async {
                        self.country = "Country data not found."
                    }
                }
            } 
            catch {
                print("Failed to parse GBIF occurrence response: \(error)")
                DispatchQueue.main.async {
                    self.country = "Error fetching country data."
                }
            }
        }
        
        occurrenceTask.resume()
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

