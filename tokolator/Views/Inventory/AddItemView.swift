import SwiftUI
import SwiftData
import PhotosUI

struct AddItemView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    @State private var item = Item()
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    HStack() {
                        Text("Name")
                            .frame(width: 80, alignment: .leading)
                        TextField("Name", text: $name)
                    }
                    
                    HStack {
                        Text("Price (Rp)")
                            .frame(width: 80, alignment: .leading)
                        TextField("Price", text: $price)
                            .keyboardType(.numberPad)
                    }
                }
                
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
                            HStack {
                                Image(systemName: "photo")
                                Text("Add Image")
                            }
                        } else {
                            HStack {
                                Image(systemName: "photo")
                                Text("Change Image")
                            }
                        }
                    }
                    
                    if item.image != nil {
                        Button(role: .destructive) {
                            withAnimation {
                                selectedPhoto = nil
                                item.image = nil
                            }
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Remove Image")
                            }
                        }
                        .tint(Color.red)
                    }
                }
                
                Section {
                    Button(action: {
                        addItem()
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Item to Inventory")
                        }
                    }
                    .tint(Color.green)
                    .disabled(name.isEmpty || price.isEmpty || selectedPhoto == nil)
                }
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
        item.price = Int(price)!
        
        modelContext.insert(item)
        presentationMode.wrappedValue.dismiss()
    }
}
