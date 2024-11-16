//
//  GalleryViewModel.swift
//  SnapEmAll
//
//  Created by Ethan Petrie on 11/15/24.
//

import Foundation
import SwiftUI

class GalleryViewModel: ObservableObject {
    
    // Published galleryItems to allow views to update dynamically and discovered animals
    // correctly represented
    @Published var galleryItems: [GalleryItem] = []

}

