//
//  LocalAnimalFinder.swift
//  SnapEmAll
//
//  Created by Ethan Petrie on 11/7/24.
//
/*
 
 userCoords = (userLat, userLong)
 localRadius = 1 //1 degree
 latMin = userLat - R
 latMax = userLat + R
 deltaLong = 1 / cos(userLat)
 longMin = userLong - deltaLong
 longMax = userLong + deltaLong
 localAnimals[] = []
 
 For an animal in GBIF occurences dataset
    if already in list of animals, skip next part
        if(latMin <= userLat <= latMax && longMin <= userLong <= longMax)
            add to list of animals to be displayed in local snappidex
 
 */
import Foundation

struct Animal: Decodable {
    let sciName: String
}

struct GBIFResponse: Decodable {
    let results: [GBIFOccurrence]
}

struct GBIFOccurrence: Decodable {
    let species: String?
    let decimalLatitude: Double?
    let decimalLongitude: Double?
}

func fetchLocalAnimals(userLat: Double, userLong: Double, completion: @escaping ([Animal]) -> Void) {
    let radius = 111000  // 1 degree in meters

    // Construct URL
    let urlString = "https://api.gbif.org/v1/occurrence/search?lat=\(userLat)&lon=\(userLong)&radius=\(radius)"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }

    // Make a network request
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching data: \(error)")
            return
        }

        guard let data = data else {
            print("No data received")
            return
        }

        do {
            // Decode
            let gbifResponse = try JSONDecoder().decode(GBIFResponse.self, from: data)
            var localAnimals: [Animal] = []

            // Add results into animal struct
            for occurrence in gbifResponse.results {
                if let species = occurrence.species {
                    // Add on to list of local animals
                    if !localAnimals.contains(where: { $0.sciName == species }) {
                        localAnimals.append(Animal(sciName: species))
                    }
                }
            }

            // Return list of animals
            completion(localAnimals)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }.resume()
}

func fetchCommonName(scientificName: String, completion: @escaping (String?) -> Void) {
    let urlString = "https://en.wikipedia.org/api/rest_v1/page/summary/\(scientificName)"
    guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching data: \(error)")
            completion(nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }
        
        do {
            // Parse the JSON to get the title or display title, which often includes the common name
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let displayTitle = json["displaytitle"] as? String {
                completion(displayTitle)
            } else {
                completion(nil)
            }
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }.resume()
}





