import SwiftUI
import SwiftData
import Combine

struct ItemDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var item: Item
    
    @FocusState private var focusedField: Field?
    
    @State private var newPrice: String = ""
    @State private var isPriceChanged: Bool = false
    @State private var showSaveAlert = false
    
    @State private var showDeleteConfirmationDialog = false
    @State private var confirmedToDelete = false
    
    private enum Field {
        case price
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    HStack {
                        Text("Price (Rp)")
                            .frame(width: 80, alignment: .leading)
                        TextField("Price", text: $newPrice)
                            .keyboardType(.numberPad)
                            .onReceive(Just(newPrice)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.newPrice = filtered
                                }
                            }
                    }
                }
                
                Section {
                    Button(action: {
                        saveItem()
                    }, label: {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Save Item")
                        }
                    })
                    .tint(Color.green)
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
                    .tint(Color.red)
                    .confirmationDialog("Delete Item", isPresented: $showDeleteConfirmationDialog, titleVisibility: .visible) {
                        Button("Delete", role: .destructive) {
                            confirmedToDelete = true
                        }
                        
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Are you sure you want to delete this item?")
                    }
                }
            }
            .navigationTitle("\(item.name)")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    focusedField = nil
                }
            }
        }
        .onAppear {
            newPrice = String(item.price)
        }
        .onChange(of: newPrice) {
            if Int(newPrice) != item.price {
                isPriceChanged = true
            } else {
                isPriceChanged = false
            }
        }
        .onChange(of: confirmedToDelete) {
            if confirmedToDelete {
                deleteItem()
            }
        }
    }
    
    private func saveItem() {
        if let inputPrice = Int(newPrice) {
            item.price = inputPrice
        } else {
            item.price = 0
        }
        
        showSaveAlert = true
    }
    
    private func deleteItem() {
        modelContext.delete(item)
        presentationMode.wrappedValue.dismiss()
    }
}
