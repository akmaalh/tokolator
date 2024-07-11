import SwiftUI
import SwiftData

struct InventoryView: View {
    @Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]
    @State private var selectedItem: Item? = nil
    @State private var isRestockViewPresented: Bool = false
    @State private var isAddItemViewPresented: Bool = false
    
    var body: some View {
        VStack {
            if items.isEmpty {
                ContentUnavailableView(label: {
                    Label("Empty Inventory", systemImage: "shippingbox")
                }, description: {
                    Text("You do not have any items in your inventory")
                }, actions: {
                    Button(action: {
                        isAddItemViewPresented = true
                    }, label: {
                        Text("Add Item")
                    })
                    .buttonStyle(.borderedProminent)
                })
            } else {
                List {
                    ForEach(items) { item in
                        Button(action: {
                            selectedItem = item
                        }) {
                            Text("\(item.name) [\(item.stock)]")
                                .foregroundColor(Color.primary)
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        isAddItemViewPresented = true
                    }, label: {
                        Text("Add Item")
                    })
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: {
                        isRestockViewPresented = true
                    }, label: {
                        Text("Restock")
                    })
                    .buttonStyle(.borderedProminent)
                    .disabled(items.isEmpty)
                }
                .padding()
            }
        }
        .sheet(item: $selectedItem) { item in
            ItemDetailView(item: item)
        }
        .sheet(isPresented: $isRestockViewPresented) {
            RestockView()
        }
        .sheet(isPresented: $isAddItemViewPresented) {
            AddItemView()
        }
    }
}

#Preview {
    InventoryView()
}
