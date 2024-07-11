import SwiftUI
import SwiftData

struct InventoryView: View {
    @Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]
    @State private var selectedItem: Item? = nil
    @State private var isRestockViewPresented: Bool = false
    @State private var isAddItemViewPresented: Bool = false
    
    var body: some View {
        VStack {
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
            }
            .padding()
        }
        .sheet(item: $selectedItem) { item in
//            ItemDetailView(item: item)
        }
        .sheet(isPresented: $isRestockViewPresented) {
//            RestockView()
        }
        .sheet(isPresented: $isAddItemViewPresented) {
            AddItemView()
        }
    }
}

#Preview {
    InventoryView()
}
