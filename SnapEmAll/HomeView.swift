import SwiftUI

struct HomeView: View {
    // Binding variables to track login state and user information
    @Binding var isSignedIn: Bool  // Tracks if the user is signed in
    @Binding var isAdmin: Bool     // Tracks if the user has admin privileges
    @Binding var username: String  // Username of the logged-in user
    @Binding var password: String  // Password of the logged-in user
    
    var resetLoginState: () -> Void // Callback to reset login state when logging out

    // State variables for local behavior
    @State private var showCamera = false          // Controls camera view visibility
    @State private var isUserView = false          // Tracks whether the admin is in User View mode
    private let forestImages = ["forest1", "forest2", "forest3"] // List of background forest images
    @State private var randomForestImage: String = ""            // Randomly selected background image
    @State private var capturedImage: UIImage?     // Stores the last captured image
    @StateObject private var galleryViewModel = GalleryViewModel() // ViewModel for the gallery

    // Initializer for passing bindings and initializing state
    init(isSignedIn: Binding<Bool>, isAdmin: Binding<Bool>, username: Binding<String>, password: Binding<String>, resetLoginState: @escaping () -> Void) {
        _isSignedIn = isSignedIn
        _isAdmin = isAdmin
        _username = username
        _password = password
        self.resetLoginState = resetLoginState
        _randomForestImage = State(initialValue: forestImages.randomElement() ?? "forest1") // Randomize initial image
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Image with blur
                Image(randomForestImage)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 10) // Adds a blur effect to the background
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Title with shadow effect
                    Text("Home Page")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 5)

                    // Button to toggle User View for admins
                    if isAdmin {
                        Button(action: {
                            isUserView.toggle()
                        }) {
                            Text(isUserView ? "User View" : "Admin View")
                                .font(.headline)
                                .padding()
                                .background(isUserView ? Color.green.opacity(0.8) : Color.gray.opacity(0.8)) // Changes color based on state
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }

                    // Navigation button to Snappidex
                    NavigationLink(destination: SnappidexView()) {
                        Text("Snappidex")
                            .font(.title)
                            .frame(width: 250, height: 60)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.blue)
                            .border(Color.blue, width: 2)
                            .cornerRadius(10)
                    }

                    // Button to open the camera
                    Button(action: {
                        showCamera = true
                    }) {
                        Text("Open Camera")
                            .font(.title)
                            .frame(width: 250, height: 60)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.purple)
                            .border(Color.purple, width: 2)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showCamera) {
                        CameraView(capturedImage: $capturedImage) // Presents the camera view
                    }

                    // Navigation button to view the gallery
                    NavigationLink(destination: GalleryView(galleryViewModel: galleryViewModel)) {
                        Text("View Gallery")
                            .font(.title)
                            .frame(width: 250, height: 60)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.green)
                            .border(Color.green, width: 2)
                            .cornerRadius(10)
                    }

                    // Admin-only buttons to edit gallery and animals
                    if isAdmin && !isUserView {
                        NavigationLink(destination: InspectUserGalleriesView()) {
                            Text("Edit Gallery")
                                .font(.title)
                                .frame(width: 250, height: 60)
                                .background(Color.white.opacity(0.8))
                                .foregroundColor(.orange)
                                .border(Color.orange, width: 2)
                                .cornerRadius(10)
                        }

                        NavigationLink(destination: EditAnimalsView()) {
                            Text("Edit Animals")
                                .font(.title)
                                .frame(width: 250, height: 60)
                                .background(Color.white.opacity(0.8))
                                .foregroundColor(.orange)
                                .border(Color.orange, width: 2)
                                .cornerRadius(10)
                        }
                    }

                    Spacer()

                    // Logout button
                    Button(action: {
                        isSignedIn = false
                        resetLoginState() // Callback to reset login state
                    }) {
                        Text("Logout")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 20) // Adds padding to avoid overlap
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
            )
            .onAppear {
                // Randomize the background image whenever the view appears
                randomForestImage = forestImages.randomElement() ?? "forest1"
            }
        }
    }
}
