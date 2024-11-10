import SwiftUI

struct HomeView: View {
    @Binding var isSignedIn: Bool
    @Binding var isAdmin: Bool
    @Binding var username: String
    @Binding var password: String
    
    @State private var showCamera = false
    @State private var isUserView = false  // State to track User View
    private let forestImages = ["forest1", "forest2", "forest3"]  // List of forest images
    @State private var randomForestImage: String = ""
    @State private var capturedImage: UIImage? // This holds the last captured image

    init(isSignedIn: Binding<Bool>, isAdmin: Binding<Bool>, username: Binding<String>, password: Binding<String>) {
        _isSignedIn = isSignedIn
        _isAdmin = isAdmin
        _username = username
        _password = password
        _randomForestImage = State(initialValue: forestImages.randomElement() ?? "forest1")  // Randomize initial image
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Image with Reduced Blur
                Image(randomForestImage)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 10)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {  
                    // Title with black outline around the letters
                    ZStack {
                        // Outline layers
                        Text("Home Page")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(.black)
                            .offset(x: -1, y: -1)
                        
                        Text("Home Page")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(.black)
                            .offset(x: 1, y: -1)
                        
                        Text("Home Page")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(.black)
                            .offset(x: -1, y: 1)
                        
                        Text("Home Page")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(.black)
                            .offset(x: 1, y: 1)
                        
                        // Main text
                        Text("Home Page")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                    }
                    
                    // Admin/User View Button
                    if isAdmin {
                        Button(action: {
                            isUserView.toggle()
                        }) {
                            Text(isUserView ? "User View" : "Admin View")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(8)
                                .background(isUserView ? Color.green.opacity(0.8) : Color.gray.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, -10) // Slightly move it up below the settings
                    }

                    // Buttons
                    NavigationLink(destination: MapView()) {
                        Text("Map")
                            .font(.title)
                            .frame(width: 250, height: 60)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.blue)
                            .border(Color.blue, width: 2)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: SnappidexView()) {
                        Text("Snappidex")
                            .font(.title)
                            .frame(width: 250, height: 60)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.blue)
                            .border(Color.blue, width: 2)
                            .cornerRadius(10)
                    }

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
                        CameraView(capturedImage: $capturedImage)
                    }

                    if isAdmin && !isUserView {
                        NavigationLink(destination: EditSnappidexView()) {
                            Text("Edit Snappidex")
                                .font(.title)
                                .frame(width: 250, height: 60)
                                .background(Color.white.opacity(0.8))
                                .foregroundColor(.red)
                                .border(Color.red, width: 2)
                                .cornerRadius(10)
                        }
                    }

                    NavigationLink(destination: GalleryView()) {
                        Text("View Gallery")
                            .font(.title)
                            .frame(width: 250, height: 60)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.green)
                            .border(Color.green, width: 2)
                            .cornerRadius(10)
                    }

                    Spacer()

                    Button(action: {
                        isSignedIn = false
                        username = ""
                        password = ""
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
                .padding(.top, 20)  // Added padding for proper layout
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: VStack {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
            )
        }
        .onAppear {
            // Randomize the background image each time the view appears
            randomForestImage = forestImages.randomElement() ?? "forest1"
        }
    }
}

#Preview {
    HomeView(isSignedIn: .constant(true), isAdmin: .constant(true), username: .constant(""), password: .constant(""))
}
