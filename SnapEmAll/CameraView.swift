//
//  CameraView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 11/3/24.
import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    
    // Variable to store the captured image
    @Binding var capturedImage: UIImage?
    
    // Coordinator to manage the camera
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            // Retrieve photo taken
            if let image = info[.originalImage] as? UIImage {
                // Save the image to the app's documents directory
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    let fileName = UUID().uuidString + ".jpg"
                    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
                    
                    do {
                        try imageData.write(to: fileURL)
                    } catch {
                        print("Error saving image: \(error)")
                    }
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    // Environment variable to control the presentation
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


