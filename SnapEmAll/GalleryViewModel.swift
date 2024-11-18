//
//  GalleryViewModel.swift
//  SnapEmAll
//
//  Created by Ethan Petrie on 11/15/24.
//

import Foundation
import SwiftUI

// GalleryViewModel: A view model class that manages the state and data for the gallery.
class GalleryViewModel: ObservableObject {
    
    // Published property to hold the list of gallery items.
    // This allows SwiftUI views to automatically update when the data changes.
    @Published var galleryItems: [GalleryItem] = []

}
