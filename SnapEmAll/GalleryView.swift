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

func addDummyImage() {
    if let dummyImage = UIImage(systemName: "photo") { // Using a system image as a placeholder
        if let imageData = dummyImage.jpegData(compressionQuality: 0.8) {
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("dummyImage.jpg")
            
            do {
                try imageData.write(to: fileURL)
            } catch {
                print("Error saving dummy image: \(error)")
            }
        }
    }
}

struct GalleryItem: Identifiable {
    let id = UUID()
    let image: UIImage
    let animalName: String
}

struct GalleryView: View {
    @State private var galleryItems: [GalleryItem] = []
    @State private var selectedGalleryItem: GalleryItem?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(galleryItems) { item in
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
            GalleryPhotoView(galleryItem: item)
        }
    }
    
    func loadGalleryItems() {
        var items: [GalleryItem] = []
        
        // Load actual photos and assign a placeholder name "Unknown Animal" if not identified
        let realPhotos = loadImages()
        for photo in realPhotos {
            items.append(GalleryItem(image: photo, animalName: "Unknown Animal"))
        }
        
        // Populate `galleryItems` with actual images and animal names.
        if galleryItems.isEmpty {
            galleryItems = [
                GalleryItem(image: UIImage(systemName: "photo")!, animalName: "Snowshoe Hare"),
                GalleryItem(image: UIImage(systemName: "photo")!, animalName: "Bald Eagle")
            ]
        }
        
        // Update the gallery items with both real and dummy data
        galleryItems = items
    }
}



#Preview {
    GalleryView()
}
