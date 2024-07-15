import SwiftUI
import SwiftData

@Observable
class InventoryViewModel {
    var modelContext: ModelContext? = nil
    var items: [Item] = []
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var selectedItem: Item?
    var isRestockViewPresented: Bool = false
    var isAddItemViewPresented: Bool = false
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        fetchItems()
    }
    
    func fetchItems() {
        let fetchDescriptor = FetchDescriptor<Item>(
            sortBy: [SortDescriptor(\.timestamp)]
        )
        
        do {
            items = try modelContext?.fetch(fetchDescriptor) ?? []
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
            items = []
        }
    }
    
    func openRestockView() {
        isRestockViewPresented = true
    }
    
    func openAddItemView() {
        isAddItemViewPresented = true
    }
}
