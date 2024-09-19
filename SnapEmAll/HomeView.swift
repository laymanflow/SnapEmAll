import SwiftUI

struct HomeView: View {
    // Binding to manage the sign-in state from ContentView
    @Binding var isSignedIn: Bool
    @Binding var username: String
    @Binding var password: String
    
    var body: some View {
        NavigationView {
            VStack {

                Text("Home Page")
                    .font(.system(size: 40, weight: .bold, design: .serif))  // bold font
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                
                // Logout button
                Button(action: {
                    // Logout and reset credentials
                    isSignedIn = false
                    username = ""  // Clear the username
                    password = ""  // Clear the password
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
                    Image(systemName: "gearshape.fill")  // Gear icon for settings
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
            )
        }
    }
}

#Preview {
    HomeView(isSignedIn: .constant(true), username: .constant(""), password: .constant(""))
}
