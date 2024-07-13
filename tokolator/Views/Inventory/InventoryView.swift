import SwiftUI
import SwiftData

struct InventoryView: View {
    @Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]
    @State private var selectedItem: Item?
    @State private var isRestockViewPresented: Bool = false
    @State private var isAddItemViewPresented: Bool = false
    
    var body: some View {
        VStack {
            if items.isEmpty {
                ContentUnavailableView(label: {
                    Label("Empty Inventory", systemImage: "shippingbox")
                }, description: {
                    Text("You do not have any items in your inventory")
                }, actions: {})
            } else {
                List {
                    ForEach(items) { item in
                        Button(action: {
                            selectedItem = item
                        }) {
                            Text("\(item.name) [Stock: \(item.stock)]")
                                .foregroundColor(Color.primary)
                        }
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    isRestockViewPresented = true
                }) {
                    Text("RESTOCK")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(items.isEmpty)
                
                Button(action: {
                    isAddItemViewPresented = true
                }) {
                    Text("ADD ITEM")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
            .fontWeight(.heavy)
            .background(.ultraThinMaterial)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
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
