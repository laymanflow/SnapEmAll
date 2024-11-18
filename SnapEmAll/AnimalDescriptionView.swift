import SwiftUI

// Cache to hold the data fetched from Wikipedia and GBIF APIs to avoid redundant network requests.
class AnimalCache {
    static var shared = AnimalCache() // Singleton instance of the cache.
    var descriptionCache: [String: String] = [:]  // Caches animal descriptions.
    var imageCache: [String: String] = [:]        // Caches animal image URLs.
    var scientificNameCache: [String: String] = [:] // Caches animal scientific names.
    var countryCache: [String: String] = [:] // Caches countries of origin for animals.
}

// View to display detailed information about a specific animal.
struct AnimalDescriptionView: View {
    let animalName: String // The name of the animal being described.
    @State private var description: String = "Loading..." // The description of the animal.
    @State private var imageUrl: String? // The URL of the animal's image.
    @State private var scientificName: String = "Loading..." // The scientific name of the animal.
    @State private var country: String = "Loading..." // The country of origin of the animal.
    
    var body: some View {
        VStack {
            // Display the animal name as the title.
            Text(animalName)
                .font(.largeTitle)
                .padding()
            
            // Display the scientific name of the animal.
            Text("Scientific Name:")
                .font(.title2)
                .fontWeight(.semibold)
            Text(scientificName)
                .font(.title3)
                .italic()
                .foregroundColor(.gray)

            // Display the country of origin for the animal.
            Text("Country of origin:")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 10)
            Text(country)
                .font(.title3)
                .foregroundColor(.gray)
            
            // Display an image of the animal fetched from Wikipedia, if available.
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
            
            // Display the description of the animal.
            Text(description)
                .font(.body)
                .padding()
            
            Spacer()
        }
        .onAppear {
            // Load animal data from the cache or fetch it from external APIs if not cached.
            loadFromAnimalCache(animal: animalName)
        }
    }
    
    /// Checks if the animal data is already cached. If not, fetches it from Wikipedia and GBIF APIs.
    func loadFromAnimalCache(animal: String) {
        if let cachedDescription = AnimalCache.shared.descriptionCache[animal],
           let cachedImageUrl = AnimalCache.shared.imageCache[animal],
           let cachedScientificName = AnimalCache.shared.scientificNameCache[animal],
           let cachedCountry = AnimalCache.shared.countryCache[animal] {
            // Use cached data.
            print("Loading \(animal) from cache.")
            description = cachedDescription
            imageUrl = cachedImageUrl
            scientificName = cachedScientificName
            country = cachedCountry
        } else {
            // Fetch data if not already cached.
            print("Fetching \(animal) from external sources.")
            fetchAnimalDescription(animal: animal)
            fetchDataGBIF(animal: animal)
        }
    }
    
    /// Fetches the scientific name and country of origin of the animal using GBIF APIs.
    func fetchDataGBIF(animal: String) {
        // Construct the GBIF species search API URL.
        let speciesUrlString = "https://api.gbif.org/v1/species/search?q=\(animal.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? animal)"
        
        guard let speciesUrl = URL(string: speciesUrlString) else {
            print("Invalid GBIF species URL")
            return
        }
        
        // Fetch the scientific name of the animal.
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
                    // Find the correct result with genus and species rank.
                    if let correctResult = results.first(where: {
                        ($0["rank"] as? String == "SPECIES") && ($0["kingdom"] as? String == "Animalia")
                    }), let fetchedScientificName = correctResult["scientificName"] as? String {
                        
                        DispatchQueue.main.async {
                            self.scientificName = fetchedScientificName
                            AnimalCache.shared.scientificNameCache[animal] = fetchedScientificName
                        }
                        
                        // Fetch the country of origin using the scientific name.
                        self.fetchCountryGBIF(scientificName: fetchedScientificName, animal: animal)
                        
                    } else {
                        DispatchQueue.main.async {
                            self.scientificName = "Scientific name not found."
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.scientificName = "Scientific name not found."
                    }
                }
            } catch {
                print("Failed to parse GBIF response: \(error)")
                DispatchQueue.main.async {
                    self.scientificName = "Error fetching scientific name."
                }
            }
        }
        
        speciesTask.resume()
    }
    
    /// Fetches the country of origin for the species using the GBIF occurrence API.
    func fetchCountryGBIF(scientificName: String, animal: String) {
        let occurrenceUrlString = "https://api.gbif.org/v1/occurrence/search?scientificName=\(scientificName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? scientificName)&hasCoordinate=true"
        
        guard let occurrenceUrl = URL(string: occurrenceUrlString) else {
            print("Invalid GBIF occurrence URL")
            return
        }
        
        // Fetch the country for the species.
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
                    
                } else {
                    DispatchQueue.main.async {
                        self.country = "Country data not found."
                    }
                }
            } catch {
                print("Failed to parse GBIF occurrence response: \(error)")
                DispatchQueue.main.async {
                    self.country = "Error fetching country data."
                }
            }
        }
        
        occurrenceTask.resume()
    }

    /// Fetches the animal's description and image from Wikipedia.
    func fetchAnimalDescription(animal: String) {
        let encodedAnimal = animal.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? animal
        if let url = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(encodedAnimal)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let extract = json["extract"] as? String,
                       let thumbnail = json["thumbnail"] as? [String: Any],
                       let imageSource = thumbnail["source"] as? String {
                        
                        DispatchQueue.main.async {
                            description = extract
                            imageUrl = imageSource
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
