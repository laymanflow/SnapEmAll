//
//  GalleryPhotoView.swift
//  SnapEmAll
//
//  Created by Ethan Petrie on 11/9/24.
//

import SwiftUI

struct GalleryPhotoView: View {
    let galleryItem: GalleryItem
    @State private var isAnimalDescriptionViewPresented = false
    
    var body: some View {
        VStack {
            // Display animal name as a tappable text that opens `AnimalDescriptionView`
            Text(galleryItem.animalName)
                .font(.title)
                .padding()
                .onTapGesture {
                    isAnimalDescriptionViewPresented = true
                }
            
            // Display the enlarged image
            Image(uiImage: galleryItem.image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
        }
        .sheet(isPresented: $isAnimalDescriptionViewPresented) {
            AnimalDescriptionView(animalName: galleryItem.animalName)
        }
    }
}
