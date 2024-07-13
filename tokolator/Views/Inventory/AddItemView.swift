import SwiftUI
import SwiftData
import PhotosUI
import Combine

struct AddItemView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    @State private var item = Item()
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    HStack {
                        Text("Name")
                            .frame(width: 80, alignment: .leading)
                        TextField("Name", text: $name)
                    }
                    
                    HStack {
                        Text("Price (Rp)")
                            .frame(width: 80, alignment: .leading)
                        TextField("Price", text: $price)
                            .keyboardType(.numberPad)
                            .onReceive(Just(price)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.price = filtered
                                }
                            }
                    }
                }
                
                Section(header: Text("Item Image")) {
                    if let imageData = item.image,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
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
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Item Added"),
                            message: Text("The item has been successfully added to your inventory."),
                            dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
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
        
        if let inputPrice = Int(price) {
            item.price = inputPrice
        } else {
            item.price = 0
        }
        
        modelContext.insert(item)
        
        do {
            try modelContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to save item: \(error)")
        }
        
        //        showAlert = true
    }
}
