import SwiftUI
import SwiftData
import PhotosUI

struct AddItemView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    @State private var item = Item()
    
    @State private var name: String = ""
    @State private var price: Int = 0
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Image")) {
                    if let imageData = item.image ,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 300)
                    }
                    
                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        if selectedPhoto == nil {
                            Label("Add Image", systemImage: "photo")
                        } else {
                            Label("Change Image", systemImage: "photo")
                            
                        }
                    }
                    
                    if item.image != nil {
                        Button(role: .destructive) {
                            withAnimation {
                                selectedPhoto = nil
                                item.image = nil
                            }
                        } label: {
                            Label("Remove Image", systemImage: "trash")
                                .foregroundColor(Color.red)
                        }
                    }
                }
                
                Section(header: Text("Item Details")) {
                    TextField("Name", text: $name)
                    TextField("Price", value: $price, format: .number)
                        .keyboardType(.numberPad)
                }
                
                Button(action: {
                   addItem()
                }) {
                    Text("Add")
                }
                .disabled(name.isEmpty || selectedPhoto == nil)
            }
            .navigationTitle("Add New Item")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    item.image = data
                }
            }
        }
    }
    
    private func addItem() {
        item.name = name
        item.price = price
        
        modelContext.insert(item)
        presentationMode.wrappedValue.dismiss()
    }
}
