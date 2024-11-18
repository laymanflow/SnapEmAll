import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

// This struct provides a camera interface for the app using UIKit, allowing users to take photos.
struct CameraView: UIViewControllerRepresentable {
    
    // Captured image is stored in this binding variable to make it accessible to the parent view.
    @Binding var capturedImage: UIImage?
    
    // The Coordinator manages interactions between the UIKit components (camera) and SwiftUI.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraView  // Reference to the parent CameraView for state updates.
        private let db = Firestore.firestore()  // Firestore database instance.
        private let storage = Storage.storage(url: "gs://snapemall.firebasestorage.app") // Firebase Storage instance.

        init(parent: CameraView) {
            self.parent = parent
        }
        
        // Dismisses the camera view when the user cancels taking a photo.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        // Handles the process after a user captures a photo.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            
            // Checks if a valid image was captured.
            if let image = info[.originalImage] as? UIImage {
                // Updates the captured image in the parent view.
                parent.capturedImage = image
                
                // Ensures the user is authenticated.
                guard let uid = Auth.auth().currentUser?.uid else {
                    print("Error: User not authenticated")
                    parent.presentationMode.wrappedValue.dismiss()
                    return
                }
                
                // Converts the image to JPEG data for storage.
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    print("Error: Unable to convert image to JPEG data")
                    parent.presentationMode.wrappedValue.dismiss()
                    return
                }
                
                // Generates a unique name for the image file.
                let imageName = UUID().uuidString + ".jpg"
                let storagePath = "\(uid)/\(imageName)"
                
                // Uploads the image to Firebase Storage.
                let storageRef = storage.reference(withPath: storagePath)
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        print("Error uploading image to Firebase Storage: \(error.localizedDescription)")
                        return
                    }
                    
                    print("Image successfully uploaded to Firebase Storage at path: \(storagePath)")
                    
                    // Prepares metadata for the uploaded image to be stored in Firestore.
                    let animalName = "Unknown Animal" // Placeholder name for the image.
                    let description = "Captured using the app" // Optional description for the image.
                    
                    let imageDocument: [String: Any] = [
                        "imagePath": storagePath,  // Path to the image in Firebase Storage.
                        "animalName": animalName, // Name of the animal (placeholder for now).
                        "description": description, // Optional description.
                    ]
                    
                    // Saves the image metadata to Firestore in a user-specific collection.
                    self.db.collection(uid).addDocument(data: imageDocument) { error in
                        if let error = error {
                            print("Error uploading image metadata to Firestore: \(error.localizedDescription)")
                        } else {
                            print("Image metadata successfully uploaded to Firestore in user-specific collection (\(uid))")
                        }
                    }
                }
            }
            
            // Dismisses the camera view after a photo is captured.
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    // Environment variable to manage the presentation of the camera view.
    @Environment(\.presentationMode) var presentationMode
    
    // Creates the Coordinator instance to handle interactions.
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // Creates and configures the UIImagePickerController for the camera interface.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator  // Assigns the Coordinator as the delegate.
        picker.sourceType = .camera  // Sets the source to the device's camera.
        picker.allowsEditing = false  // Disables editing of the captured image.
        return picker
    }
    
    // Updates the view controller (not used in this implementation).
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
