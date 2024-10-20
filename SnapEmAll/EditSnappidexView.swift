//
//  EditSnappidexView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 10/20/24.
//

import SwiftUI

struct EditSnappidexView: View {
    @State private var animals = [
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
    @State private var newAnimal: String = ""
    
    var body: some View {
        VStack {
            Text("Edit Snappidex")
                .font(.largeTitle)
                .padding()
            
            // Add new animal
            HStack {
                TextField("New Animal", text: $newAnimal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if !newAnimal.isEmpty {
                        animals.append(newAnimal)
                        newAnimal = ""
                    }
                }) {
                    Text("Add Animal")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            // Display and remove animals
            List {
                ForEach(animals, id: \.self) { animal in
                    HStack {
                        Text(animal)
                        Spacer()
                        Button(action: {
                            if let index = animals.firstIndex(of: animal) {
                                animals.remove(at: index)
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    EditSnappidexView()
}
