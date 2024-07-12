import SwiftUI
import SwiftData

struct ItemDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Bindable var item: Item
    
    @FocusState private var focusedField: Field?
    
    @State private var newPrice: Int = 0
    @State private var isPriceChanged: Bool = false
    
    private enum Field {
        case price
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    HStack {
                        Text("Price (Rp)")
                        TextField("Price", value: $newPrice, format: .number)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section {
                    Button(action: {
                        saveItem()
                    }, label: {
                        Text("Save")
                    })
                    .tint(Color.green)
                    .disabled(!isPriceChanged)
                    
                    Button(action: {
                        deleteItems(item: item)
                    }, label: {
                        Text("Delete")
                    })
                    .tint(Color.red)
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
            newPrice = item.price
        }
        .onChange(of: newPrice) {
            if newPrice != item.price {
                isPriceChanged = true
            } else {
                isPriceChanged = false
            }
        }
    }
    
    private func saveItem() {
        item.price = newPrice
        presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteItems(item: Item) {
        modelContext.delete(item)
        presentationMode.wrappedValue.dismiss()
    }
}
