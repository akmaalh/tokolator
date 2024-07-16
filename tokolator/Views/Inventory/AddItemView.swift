import SwiftUI
import SwiftData
import PhotosUI
import Combine

struct AddItemView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State var inventoryViewModel: InventoryViewModel = .init()
    @State var addItemViewModel: AddItemViewModel = .init()
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    HStack {
                        Text("Name")
                            .frame(width: 80, alignment: .leading)
                        TextField("Name", text: $addItemViewModel.name)
                            .focused($focusedField, equals: .name)
                    }
                    
                    HStack {
                        Text("Price (Rp)")
                            .frame(width: 80, alignment: .leading)
                        TextField("Price", text: $addItemViewModel.price)
                            .focused($focusedField, equals: .price)
                            .keyboardType(.numberPad)
                            .onReceive(Just(addItemViewModel.price)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.addItemViewModel.price = filtered
                                }
                            }
                    }
                }
                
                Section(header: Text("Item Image")) {
                    if let imageData = addItemViewModel.selectedPhotoData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    }
                    
                    PhotosPicker(selection: $addItemViewModel.selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        if addItemViewModel.selectedPhoto == nil {
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
                        guard let priceValue = Int(addItemViewModel.price), let photoData = addItemViewModel.selectedPhotoData else {
                            return
                        }
                        
                        inventoryViewModel.addItem(name: addItemViewModel.name, price: priceValue, photo: photoData)
                        addItemViewModel.showAlert = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Item to Inventory")
                        }
                    }
                    .tint(Color.green)
                    .disabled(!addItemViewModel.checkForm())
                    .alert(isPresented: $addItemViewModel.showAlert) {
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
            .task(id: addItemViewModel.selectedPhoto) {
                if let data = try? await addItemViewModel.selectedPhoto?.loadTransferable(type: Data.self) {
                    addItemViewModel.selectedPhotoData = data
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
        }
    }
}
