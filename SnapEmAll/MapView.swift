import SwiftUI
import MapKit


struct MapView: View {
    @State private var showSnappidex = false

    var body: some View {
        ZStack {
            
            //check if device is iOS 17 or above
            if #available(iOS 17.0, *) {
                MapViewiOS17(showSnappidex: $showSnappidex)
            } else {
                MapViewiOS16(showSnappidex: $showSnappidex)
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
                .padding(.bottom, 30)
            }
        }
        .fullScreenCover(isPresented: $showSnappidex) {
            SnappidexView()
        }
    }
}

//run for iOS 17 using MapCameraPosition
@available (iOS 17, *)
struct MapViewiOS17: View {
    @Binding var showSnappidex: Bool
    
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.050710, longitude: -76.136460),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))

    var body: some View {
        Map(position: $cameraPosition)
            .onAppear {
                cameraPosition = .region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 43.050710, longitude: -76.136460),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                ))
            }
            .ignoresSafeArea()
    }
}

//run for iOS 16 and earlier using MKCoordinateRegion
struct MapViewiOS16: View {
    @Binding var showSnappidex: Bool
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.050710, longitude: -76.136460),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    var body: some View {
        Map(coordinateRegion: $region)
            .ignoresSafeArea()
    }
}

#Preview {
    MapView()
}

