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
            
            Text("Transactions")
                .tabItem {
                    Text("Transactions")
                    Image(systemName: "newspaper")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
