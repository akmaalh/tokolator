import SwiftUI
import SwiftData
import Combine

struct ItemDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State var inventoryViewModel: InventoryViewModel = .init()
    
    @State private var price: String = ""
    @State private var isPriceChanged: Bool = false
    
    @State private var showSaveAlert = false
    @State private var showDeleteConfirmationDialog = false
    
    @State private var confirmedToDelete = false
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    HStack {
                        Text("Price (Rp)")
                            .frame(width: 80, alignment: .leading)
                        TextField("Price", text: $price)
                            .focused($focusedField, equals: .price)
                            .keyboardType(.numberPad)
                            .onReceive(Just(price)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.price = filtered
                                }
                            }
                    }
                }
                
                Section {
                    Button(action: {
                        if let newPrice = Int(price) {
                            inventoryViewModel.updateItemPrice(newPrice: newPrice)
                            showSaveAlert = true
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Save Item")
                        }
                    })
                    .tint(.green)
                    .disabled(!isPriceChanged)
                    .alert(isPresented: $showSaveAlert) {
                        Alert(
                            title: Text("Price Saved"),
                            message: Text("The price has been successfully updated."),
                            dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                    
                    Button(action: {
                        showDeleteConfirmationDialog = true
                    }, label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Item")
                        }
                    })
                    .tint(.red)
                    .confirmationDialog("Delete Item", isPresented: $showDeleteConfirmationDialog, titleVisibility: .visible) {
                        Button("Delete", role: .destructive) {
                            confirmedToDelete = true
                        }
                        
                        Button("Cancel", role: .cancel) {}
                    }
                    .onChange(of: confirmedToDelete) {
                        if confirmedToDelete {
                            inventoryViewModel.deleteItem()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .navigationTitle("\(inventoryViewModel.selectedItem?.name ?? "")")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
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
        .onAppear {
            if let selectedItem = inventoryViewModel.selectedItem {
                price = String(selectedItem.price)
            }
        }
        .onChange(of: price) {
            if let selectedItem = inventoryViewModel.selectedItem {
                let originalPrice = selectedItem.price
                if let newPrice = Int(price) {
                    if originalPrice != newPrice {
                        isPriceChanged = true
                    } else {
                        isPriceChanged = false
                    }
                }
            }
        }
    }
}
