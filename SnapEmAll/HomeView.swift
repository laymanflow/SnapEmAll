import SwiftUI

struct HomeView: View {
    @Binding var isSignedIn: Bool
    @Binding var isAdmin: Bool
    @Binding var username: String
    @Binding var password: String
    
    @State private var showCamera = false
    @State private var isUserView = false
    private let forestImages = ["forest1", "forest2", "forest3"]  // List of forest images
    @State private var randomForestImage: String = ""

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
                    .blur(radius: 10)  // Reduced blur radius for more clarity
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {  // Add spacing to improve layout
                
                    Text("Home Page")
                        .font(.system(size: 40, weight: .bold, design: .serif))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                    
                    // "User's View" Toggle for Admins
                    if isAdmin {
                        Toggle(isOn: $isUserView) {
                            Text("User's View")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Map Button
                    NavigationLink(destination: MapView()) {
                        Text("Map")
                            .font(.title)
                            .frame(width: 250, height: 60)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.blue)
                            .border(Color.blue, width: 2)
                            .cornerRadius(10)
                    }
                    
                    // Snappidex Button
                    NavigationLink(destination: SnappidexView()) {
                        Text("Snappidex")
                            .font(.title)
                            .frame(width: 250, height: 60)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.blue)
                            .border(Color.blue, width: 2)
                            .cornerRadius(10)
                    }
                    
                    // Open Camera Button
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
                        CameraView()  // Presents the camera view
                    }
                    
                    // Edit Snappidex Button (Admin Only)
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
                    
                    Spacer()
                    
                    // Logout Button
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
                    
                    Spacer()
                }
                .padding(.top, 20)  // Added padding to ensure content is not too close to the top
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large)
                        .foregroundColor(.blue)
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
