// done! ask users to import a picture from their photo library
// done! show the full collection of names in a List, sorted by name.
// done! tapping an item in the list should show a detail screen
// done! ask users to name photo
// done! Wrap PHPickerViewController so it can be used to select photos.
// done! detail screen should show a larger version of the picture
// done! show the photo in the list next to each name
// done! Detect when a new photo is imported, and immediately ask the user to name the photo.
// done! when you’re viewing a picture, show a map where user was when picture was added

// TODO Save that name and photo somewhere safe.
// TODO Decide on a way to save all this data.
// TODO add a pin to the map

import CoreLocation
import MapKit
import SwiftUI

struct ContentView: View {
    @State private var namedPhotos = [NamedPhoto]()
    
    @State private var inputImage: UIImage?
    @State private var imageName: String = ""
    
    @State private var showingImagePicker = false
    @State private var showingNameImage = false
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        if !showingNameImage {
            VStack {
                NavigationView {
                    List {
                        ForEach(namedPhotos.sorted()) { photo in
                            HStack {
                                if let image = photo.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                }
                                
                                NavigationLink(photo.name) {
                                    VStack {
                                        if let image = photo.image {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                        }
                                        
                                        Text(photo.name)
                                        
                                        if let location = photo.location {
                                            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [])
                                            
                                            Text("Location: \(location.latitude), \(location.longitude)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button {
                        locationFetcher.start()
                        showingImagePicker = true
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .background(.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage, showingNameImage: $showingNameImage)
            }
        } else {
            if let inputImage {
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFit()
            }
            
            TextField("Image name", text: $imageName)
                .textInputAutocapitalization(.never)
            
            HStack {
                Button("Save") {
                    namedPhotos.append(NamedPhoto(id: UUID(), name: imageName, image: inputImage, location: locationFetcher.lastKnownLocation))
                    inputImage = nil
                    imageName = ""
                    showingNameImage = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(imageName.isEmpty)
                
                Button("Cancel", role: .destructive) {
                    inputImage = nil
                    imageName = ""
                    showingNameImage = false
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    ContentView()
}
