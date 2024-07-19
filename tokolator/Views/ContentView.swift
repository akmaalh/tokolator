import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext


    var body: some View {
        TabView {
            CashierView(modelContext: modelContext)
                .tabItem {
                    Text("Calculator")
                    Image(systemName: "plus.forwardslash.minus")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.tabBarBG, for: .tabBar)
            
            InventoryView(inventoryViewModel: .init(modelContext: modelContext))
                .tabItem {
                    Text("Inventory")
                    Image(systemName: "bag")
                }
            
            TransactionView(modelContext: modelContext)
                .tabItem {
                    Text("Transactions")
                    Image(systemName: "newspaper")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.tabBarBG, for: .tabBar)
        }
    }
}
