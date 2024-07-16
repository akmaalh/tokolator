import SwiftUI
import SwiftData

struct InventoryView: View {
    @State var inventoryViewModel: InventoryViewModel = .init()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if inventoryViewModel.items.isEmpty {
                    ContentUnavailableView(label: {
                        Label("Empty Inventory", systemImage: "shippingbox")
                    }, description: {
                        Text("You do not have any items in your inventory")
                    }, actions: {})
                } else {
                    ScrollView {
                        LazyVGrid(columns: inventoryViewModel.columns, spacing: 8) {
                            ForEach(inventoryViewModel.items) { item in
                                Button(action: {
                                    inventoryViewModel.selectedItem = item
                                    inventoryViewModel.openItemDetailView()
                                }) {
                                    ItemCard(item: item)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
                
                HStack(spacing: 16) {
                    Button(action: {
                        inventoryViewModel.openRestockView()
                    }) {
                        Text("RESTOCK")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(inventoryViewModel.items.isEmpty)
                    
                    Button(action: {
                        inventoryViewModel.openAddItemView()
                    }) {
                        Text("ADD ITEM")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()
                .fontWeight(.heavy)
                .background(Color.tabBarBG)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Inventory")
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $inventoryViewModel.isItemDetailSheetPresented) {
                ItemDetailView(inventoryViewModel: inventoryViewModel)
            }
            .sheet(isPresented: $inventoryViewModel.isRestockViewPresented) {
                RestockView(inventoryViewModel: inventoryViewModel)
            }
            .sheet(isPresented: $inventoryViewModel.isAddItemViewPresented) {
                AddItemView(inventoryViewModel: inventoryViewModel)
            }
        }
    }
}
