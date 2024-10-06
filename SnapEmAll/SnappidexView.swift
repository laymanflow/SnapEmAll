import SwiftUI

struct SnappidexView: View {
    
    @State private var searchInput = ""
    
    let animals = [
        "White-tailed Deer",
        "Eastern Gray Squirrel",
        "Red Fox",
        "Black Bear",
        "Eastern Chipmunk",
        "Snowshoe Hare",
        "American Beaver",
        "Bald Eagle",
        "Wild Turkey",
        "Eastern Box Turtle"
    ]
    
    //filter search results based on user input
    var searchedAnimals: [String] {
        if searchInput.isEmpty {
            return animals
        } 
        else {
            return animals.filter {$0.lowercased().contains(searchInput.lowercased())}
        }
    }
    
    var body: some View {
        VStack {
            Text("Snappidex")
                .font(.largeTitle)
                .padding()
            
            TextField("Search for an animal", text: $searchInput)
                                .padding(8)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                                .padding(.horizontal)
            
            List(searchedAnimals, id: \.self) { animal in
                NavigationLink(destination: AnimalDescriptionView(animalName: animal)) {
                    Text(animal)
                        .font(.headline)
                        .padding()
                }
            }
        }
        .navigationBarTitle("Snappidex", displayMode: .inline)
    }
}


#Preview {
    SnappidexView()
}
//
//  SnappidexView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 10/5/24.
//

