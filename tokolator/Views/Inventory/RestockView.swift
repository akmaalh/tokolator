import SwiftUI
import SwiftData

class RestockItem: Identifiable {
    var id: UUID
    var itemId: UUID?
    var quantity: Int?
    var price: Int?
    
    init(itemId: UUID? = nil) {
        self.id = UUID()
        self.itemId = itemId
        self.quantity = nil
        self.price = nil
    }
}

struct RestockView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]

    @State private var restockItems: [RestockItem] = []
    @State private var showAlert = false
    
    @FocusState private var focusedField: Field?
    
    private var isFormValid: Bool {
        for item in restockItems {
            if item.itemId == nil || item.quantity == nil || item.price == nil {
                return false
            }
        }
        return true
    }
    
    private func restock() {
        for restockItem in restockItems {
            if let itemId = restockItem.itemId,
               let quantity = restockItem.quantity,
               let itemIndex = items.firstIndex(where: { $0.id == itemId }) {
                items[itemIndex].stock += quantity
            }
        }
            
        showAlert = true
    }
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(restockItems.indices, id: \.self) { index in
                    let restockItem = $restockItems[index]
                    
                    Section(header: Text("Item \(index + 1)")) {
                        Picker("Select an item", selection: restockItem.itemId) {
                            ForEach(items) { item in
                                Text(item.name)
                                    .tag(item.id as UUID?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        HStack {
                            Text("Quantity")
                                .frame(width: 80, alignment: .leading)

                            TextField("Quantity", value: restockItem.quantity, format: .number)
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .quantity)
                        }
                        
                        HStack {
                            Text("Price (Rp)")
                                .frame(width: 80, alignment: .leading)

                            TextField("Price", value: restockItem.price, format: .number)
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .price)
                        }
                        
                        Button(action: {
                            restockItems.remove(at: index)
                        }, label: {
                            Text("Remove Item")
                        })
                        .tint(Color.red)
                    }
                }
                
                Section {
                    Button(action: {
                        if let firstItemId = items.first?.id {
                            restockItems.append(RestockItem(itemId: firstItemId))
                        }
                    }, label: {
                        Text("Add Item to Restock")
                    })
                }
                
                Section {
                    Button(action: {
                        restock()
                    }, label: {
                        Text("Restock Items")
                    })
                    .tint(Color.green)
                    .disabled(!isFormValid || restockItems.isEmpty)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Items Restocked"),
                            message: Text("The items have been successfully restocked."),
                            dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }

                }
                
            }
            .navigationTitle("Restock Items")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                if restockItems.isEmpty, let firstItemId = items.first?.id {
                    restockItems = [RestockItem(itemId: firstItemId)]
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
