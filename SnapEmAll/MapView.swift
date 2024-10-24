import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()

    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.050710, longitude: -76.136460),
                                               span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: location.coordinate,
                                                 span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
        }
    }
}

struct MapView: View {
    @State private var showSnappidex = false
    @StateObject private var locationManager = LocationManager() //initializes a location manager

    var body: some View {
        ZStack {
            
            //check if device is iOS 17 or above
            if #available(iOS 17.0, *) {
                MapViewiOS17(locationManager: locationManager, showSnappidex: $showSnappidex)
            } else {
                MapViewiOS16(locationManager: locationManager, showSnappidex: $showSnappidex)
            }
            
            //button for entering the snappidex
            VStack {
                Spacer()
                Button(action: {
                    showSnappidex = true
                }) {
                    Image(systemName: "book.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 60)
            }
        }
        .fullScreenCover(isPresented: $showSnappidex) {
            SnappidexView()
        }
    }
}

//run for iOS 17 using MapCameraPosition
@available(iOS 17, *)
struct MapViewiOS17: View {
    @ObservedObject var locationManager: LocationManager
    @Binding var showSnappidex: Bool
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        ZStack {
            Map(position: $cameraPosition)
                .onAppear {
                    cameraPosition = .region(locationManager.region) // Set camera position to user region
                }
                .ignoresSafeArea()

            // Location button outside the map but overlaid on top of it
            VStack {
                Spacer()
                LocationButton(.currentLocation) {
                    // Request the user's current location
                    locationManager.locationManager.requestLocation()
                }
                .labelStyle(.iconOnly)
                .foregroundColor(.white)
                .tint(.blue)
                .clipShape(Circle())
                .padding()
            }
        }
    }
}

//run for iOS 16 and earlier using MKCoordinateRegion
struct MapViewiOS16: View {
    @ObservedObject var locationManager: LocationManager
    @Binding var showSnappidex: Bool
    
    var body: some View {
        Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
            .ignoresSafeArea()
    }
}

#Preview {
    MapView()
}

