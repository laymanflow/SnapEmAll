//
//  GalleryView.swift
//  SnapEmAll
//
//  Created by Ethan Petrie on 11/9/24.
//

import SwiftUI

func loadImages() -> [UIImage] {
    var images = [UIImage]()
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    do {
        let imageFiles = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        for url in imageFiles {
            if let image = UIImage(contentsOfFile: url.path) {
                images.append(image)
            }
        }
    } catch {
        print("Error loading images: \(error)")
    }
    return images
}

struct GalleryItem: Identifiable {
    let id = UUID()
    let image: UIImage
    var animalName: String
}

struct GalleryView: View {
    //@State private var galleryItems: [GalleryItem] = []
    @State private var selectedGalleryItem: GalleryItem?
    @ObservedObject var galleryViewModel: GalleryViewModel
    
    var discoveredAnimalNames: [String] {
        galleryViewModel.galleryItems.map { $0.animalName }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(galleryViewModel.galleryItems) { item in
                    VStack {
                        Image(uiImage: item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedGalleryItem = item
                            }
                    }
                }
            }
        }
        .onAppear {
            loadGalleryItems()
        }
        .sheet(item: $selectedGalleryItem) { item in
            GalleryPhotoView(galleryItem: item, galleryViewModel: galleryViewModel)
        }
        .navigationTitle("Gallery")
        .navigationBarItems(trailing: NavigationLink("Go to Snappidex") {
            SnappidexView(discoveredAnimals: discoveredAnimalNames)
        })
    }
    
    func loadGalleryItems() {
        var items: [GalleryItem] = []
        
        // Load actual photos and assign a placeholder name "Unknown Animal" if not identified
        let realPhotos = loadImages()
        
        // Examples for testing
        items.append(GalleryItem(image: UIImage(systemName: "hare.fill")!, animalName: "Snowshoe Hare"))
        items.append(GalleryItem(image: UIImage(systemName: "bird.fill")!, animalName: "Bald Eagle"))
        for photo in realPhotos {
            items.append(GalleryItem(image: photo, animalName: "Unknown Animal"))
        }
        
        // Populate `galleryItems` with actual images and animal names.
        if galleryViewModel.galleryItems.isEmpty {
            galleryViewModel.galleryItems = [
                GalleryItem(image: UIImage(systemName: "photo")!, animalName: "Snowshoe Hare"),
                GalleryItem(image: UIImage(systemName: "photo")!, animalName: "Bald Eagle")
            ]
        }
        
        // Update the gallery items with both real and dummy data
        galleryViewModel.galleryItems = items
    }
}

#Preview {
    let sampleGalleryViewModel = GalleryViewModel()
    sampleGalleryViewModel.galleryItems = [
        GalleryItem(image: UIImage(systemName: "hare.fill")!, animalName: "Snowshoe Hare"),
        GalleryItem(image: UIImage(systemName: "bird.fill")!, animalName: "Bald Eagle")
    ]
    return GalleryView(galleryViewModel: sampleGalleryViewModel)
}
