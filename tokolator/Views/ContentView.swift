import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext


    var body: some View {
        TabView {
            InventoryView(inventoryViewModel: .init(modelContext: modelContext))
                .tabItem {
                    Text("Inventory")
                    Image(systemName: "bag")
                }
            
            CashierView(modelContext: modelContext)
                .tabItem {
                    Text("Calculator")
                    Image(systemName: "plus.forwardslash.minus")
                }
            
            TransactionView()
                .tabItem {
                    Text("Transactions")
                    Image(systemName: "newspaper")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.navbarBG, for: .tabBar)
        }
    }
}
