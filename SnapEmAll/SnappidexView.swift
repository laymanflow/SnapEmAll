import SwiftUI

struct SnappidexView: View {
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
    
    var body: some View {
        VStack {
            Text("Snappidex")
                .font(.largeTitle)
                .padding()
            
            List(animals, id: \.self) { animal in
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

