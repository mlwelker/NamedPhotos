// done! ask users to import a picture from their photo library
// done! show the full collection of names in a List, sorted by name.
// done! tapping an item in the list should show a detail screen
// done! ask users to name photo
// done! Wrap PHPickerViewController so it can be used to select photos.
// done! detail screen should show a larger version of the picture
// done! show the photo in the list next to each name
// done! Detect when a new photo is imported, and immediately ask the user to name the photo.

// TODO Save that name and photo somewhere safe.
// TODO Decide on a way to save all this data.
// TODO when you’re viewing a picture, show a map with a pin marking where user was when picture was added


import SwiftUI

struct ContentView: View {
    @State private var namedPhotos = [NamedPhoto]()
    
    @State private var inputImage: UIImage?
    @State private var imageName: String = ""
    
    @State private var showingImagePicker = false
    @State private var showingNameImage = false
    
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
                                    }
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button {
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
                    namedPhotos.append(NamedPhoto(id: UUID(), name: imageName, image: inputImage))
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
