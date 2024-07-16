import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    
    var body: some View {
        TabView {
            InventoryView()
                .tabItem {
                    Text("Inventory")
                    Image(systemName: "bag")
                }
            
            CashierView(modelContext: modelContext)
                .tabItem {
                    Text("Calculator")
                    Image(systemName: "plus.forwardslash.minus")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.tabBarBG, for: .tabBar)
            
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

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
