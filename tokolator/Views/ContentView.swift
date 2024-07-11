import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            InventoryView()
                .tabItem {
                    Text("Inventory")
                    Image(systemName: "bag")
                }
            
            Text("Calculator")
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

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
