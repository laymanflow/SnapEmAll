import SwiftUI

struct HomeView: View {
    @Binding var isSignedIn: Bool
    @Binding var isAdmin: Bool  // Binding to check if the user is an admin
    @Binding var username: String
    @Binding var password: String
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Home Page")
                    .font(.system(size: 40, weight: .bold, design: .serif))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // "Map" button
                NavigationLink(destination: MapView()) {
                    Text("Map")
                        .font(.title)  // Make the button text larger
                        .frame(width: 250, height: 60)  // Increase button size
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .border(Color.blue, width: 2)
                        .cornerRadius(10)
                        .padding(.top, 20)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                // Only show the "Edit Snappidex" button if the user is an admin
                if isAdmin {
                    NavigationLink(destination: EditSnappidexView()) {
                        Text("Edit Snappidex")
                            .font(.title)
                            .frame(width: 250, height: 60)
                            .background(Color.white)
                            .foregroundColor(.red)
                            .border(Color.red, width: 2)
                            .cornerRadius(10)
                            .padding(.top, 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
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
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
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
    }
}

#Preview {
    HomeView(isSignedIn: .constant(true), isAdmin: .constant(true), username: .constant(""), password: .constant(""))
}
