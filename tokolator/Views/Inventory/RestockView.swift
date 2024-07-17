import SwiftUI
import SwiftData

struct RestockView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State var inventoryViewModel: InventoryViewModel = .init()
    @State var restockViewModel: RestockViewModel = .init()
    
    @FocusState private var focusedField: Field?

    var body: some View {
        NavigationView {
            Form {
                ForEach(restockViewModel.restockItems.indices, id: \.self) { index in
                    let restockItem = $restockViewModel.restockItems[index]
                    
                    Section(header: Text("Item \(index + 1)")) {
                        Picker("Select an item", selection: restockItem.itemId) {
                            ForEach(inventoryViewModel.items) { item in
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
                            
                            TextField("Price Buy Per Item", value: restockItem.price, format: .number)
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .price)
                        }
                        
                        Button(action: {
                            restockViewModel.restockItems.remove(at: index)
                        }, label: {
                            Text("Remove Item")
                        })
                        .tint(Color.red)
                    }
                }
                
                Section {
                    Button(action: {
                        if let firstItemId = inventoryViewModel.items.first?.id {
                            restockViewModel.restockItems.append(RestockItem(itemId: firstItemId))
                        }
                    }, label: {
                        Text("Add Item to Restock")
                    })
                }
                
                Section {
                    Button(action: {
                        inventoryViewModel.restockItems(restockViewModel: restockViewModel)
                    }, label: {
                        Text("Restock Items")
                    })
                    .tint(Color.green)
                    .disabled(!restockViewModel.checkForm())
                    .alert(isPresented: $restockViewModel.showAlert) {
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
                if restockViewModel.restockItems.isEmpty, let firstItemId = inventoryViewModel.items.first?.id {
                    restockViewModel.restockItems = [RestockItem(itemId: firstItemId)]
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
