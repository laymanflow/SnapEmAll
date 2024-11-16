//
//  CameraView.swift
//  SnapEmAll
//
//  Created by GeoHaun on 11/3/24.
import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseAuth

struct CameraView: UIViewControllerRepresentable {
    
    @Binding var capturedImage: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraView
        private let db = Firestore.firestore()
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.originalImage] as? UIImage {
                // Set the captured image to the binding variable
                parent.capturedImage = image
                
                // Convert image to Base64 string
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    print("Error: Unable to convert image to JPEG data")
                    parent.presentationMode.wrappedValue.dismiss()
                    return
                }
                let base64String = imageData.base64EncodedString()
                
                // Firestore metadata for the image
                let animalName = "Unknown Animal" // Placeholder name
                let description = "Captured using the app" // Optional description
                
                // Ensure user is authenticated
                guard let uid = Auth.auth().currentUser?.uid else {
                    print("Error: User not authenticated")
                    parent.presentationMode.wrappedValue.dismiss()
                    return
                }
                
                // Create a document in the user's UID container
                let imageDocument: [String: Any] = [
                    "imageData": base64String,
                    "animalName": animalName,
                    "description": description,
                ]
                
                db.collection(uid).addDocument(data: imageDocument) { error in
                    if let error = error {
                        print("Error uploading image to Firestore: \(error.localizedDescription)")
                    } else {
                        print("Image successfully uploaded to Firestore in user-specific collection (\(uid))")
                    }
                }
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
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
