//
//  GalleryPhotoView.swift
//  SnapEmAll
//
//  Created by Ethan Petrie on 11/9/24.
//

import SwiftUI

struct GalleryPhotoView: View {
    @State private var isLogAnimalViewPresented = false             // Controls display of LogAnimalView
    @State private var isAnimalDescriptionViewPresented = false     // Controls display of AnimalDescriptionView
    let galleryItem: GalleryItem                                    // A user's gallery item including photo and animal
    @ObservedObject var galleryViewModel: GalleryViewModel          // Import galleryViewModel object to sync values
    
    var body: some View {
        VStack {
            
            // Only opens LogAnimalView if animal is marked as unknown
            if galleryItem.animalName == "Unknown Animal" {
                Button("Log Animal") {
                    isLogAnimalViewPresented = true
                }
                
                // Opens the LogAnimalView and allows the user to choose their animal
                .sheet(isPresented: $isLogAnimalViewPresented) {
                    LogAnimalView(
                        capturedImage: galleryItem.image,
                        viewModel: SnappidexViewModel(),
                        galleryViewModel: galleryViewModel
                    ) { selectedAnimal in
                        if let index = galleryViewModel.galleryItems.firstIndex(where: { $0.id == galleryItem.id }) {
                            galleryViewModel.galleryItems[index].animalName = selectedAnimal
                        }
                    }
                }
            }
            
            // If the animal is already logged, display it's name at the top and link it to the
            // corresponding animal description view.
            else {
                Text(galleryItem.animalName)
                    .font(.title)
                    .padding()
                    .onTapGesture {
                        isAnimalDescriptionViewPresented = true
                    }
                    .sheet(isPresented: $isAnimalDescriptionViewPresented) {
                        AnimalDescriptionView(animalName: galleryItem.animalName)
                    }
            }
            
            //Display the user's photo
            Image(uiImage: galleryItem.image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Spacer()
        }
    }
}
