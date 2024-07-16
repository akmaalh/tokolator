import SwiftUI
import SwiftData
import Combine

struct ItemDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State var inventoryViewModel: InventoryViewModel
    @State var itemDetailViewModel: ItemDetailViewModel = .init()
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    HStack {
                        Text("Price (Rp)")
                            .frame(width: 80, alignment: .leading)
                        TextField("Price", text: $itemDetailViewModel.price)
                            .focused($focusedField, equals: .price)
                            .keyboardType(.numberPad)
                            .onReceive(Just(itemDetailViewModel.price)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.itemDetailViewModel.price = filtered
                                }
                            }
                    }
                }
                
                Section {
                    Button(action: {
                        if let newPrice = Int(itemDetailViewModel.price) {
                            inventoryViewModel.updateItemPrice(newPrice: newPrice)
                            itemDetailViewModel.showSaveAlert = true
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Save Item")
                        }
                    })
                    .tint(.green)
                    .disabled(!itemDetailViewModel.isPriceChanged)
                    .alert(isPresented: $itemDetailViewModel.showSaveAlert) {
                        Alert(
                            title: Text("Price Saved"),
                            message: Text("The price has been successfully updated."),
                            dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                    
                    Button(action: {
                        itemDetailViewModel.showDeleteConfirmationDialog = true
                    }, label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Item")
                        }
                    })
                    .tint(.red)
                    .confirmationDialog(Text("Delete Item"), isPresented: $itemDetailViewModel.showDeleteConfirmationDialog, titleVisibility: .visible) {
                        Button("Delete", role: .destructive) {
                            itemDetailViewModel.confirmedToDelete = true
                        }
                        
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Are you sure you want to delete \(inventoryViewModel.selectedItem!.name)?")
                    }
                    .onChange(of: itemDetailViewModel.confirmedToDelete) {
                        if itemDetailViewModel.confirmedToDelete {
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
                itemDetailViewModel.price = String(selectedItem.price)
            }
        }
        .onChange(of: itemDetailViewModel.price) {
            if let selectedItem = inventoryViewModel.selectedItem {
                let originalPrice = selectedItem.price
                if let newPrice = Int(itemDetailViewModel.price) {
                    itemDetailViewModel.isPriceChanged = originalPrice != newPrice
                }
            }
        }
    }
}
