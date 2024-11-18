//
//  EditSnappidexView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 10/20/24.
//

import SwiftUI

/// View to edit the Snappidex by adding or removing animals from the list.
struct EditSnappidexView: View {
    @State private var animals = [ // List of animals in the Snappidex.
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
    @State private var newAnimal: String = "" // Holds the input for a new animal to be added.

    var body: some View {
        VStack {
            // Title
            Text("Edit Snappidex")
                .font(.largeTitle)
                .padding()

            // Section to add a new animal
            HStack {
                // Input field for the new animal's name
                TextField("New Animal", text: $newAnimal)
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // Adds a rounded border style.
                    .padding()

                // Button to add the new animal to the list
                Button(action: {
                    if !newAnimal.isEmpty { // Ensure the input field is not empty.
                        animals.append(newAnimal) // Add the new animal to the list.
                        newAnimal = "" // Clear the input field after adding.
                    }
                }) {
                    Text("Add Animal")
                        .padding()
                        .background(Color.green) // Green background for the button.
                        .foregroundColor(.white) // White text color.
                        .cornerRadius(8) // Rounded corners for the button.
                }
            }
            .padding(.horizontal) // Adds horizontal padding to the input and button.

            // Section to display and remove animals
            List {
                // Iterate over the list of animals
                ForEach(animals, id: \.self) { animal in
                    HStack {
                        // Display the animal's name
                        Text(animal)
                        Spacer() // Push the trash button to the right.
                        
                        // Button to remove the animal from the list
                        Button(action: {
                            if let index = animals.firstIndex(of: animal) { // Find the animal's index.
                                animals.remove(at: index) // Remove the animal from the list.
                            }
                        }) {
                            Image(systemName: "trash") // Trash icon.
                                .foregroundColor(.red) // Red color for the trash icon.
                        }
                    }
                }
            }

            Spacer() // Pushes the content to the top of the screen.
        }
        .padding() // Adds padding around the entire view.
    }
}

#Preview {
    EditSnappidexView()
}
