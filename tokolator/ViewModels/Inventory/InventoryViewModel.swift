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
    var isItemDetailSheetPresented: Bool = false
    var isRestockViewPresented: Bool = false
    var isAddItemViewPresented: Bool = false
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        fetchItems()
    }
    
    func fetchItems() {
        let fetchDescriptor = FetchDescriptor<Item>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        
        do {
            items = try modelContext?.fetch(fetchDescriptor) ?? []
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
            items = []
        }
    }
    
    func addItem(name: String, price: Int, photo: Data) {
        guard let modelContext else { return }
        
        let item = Item(name: name, price: price)
        item.image = photo
        
        modelContext.insert(item)
        fetchItems()
    }
    
    func updateItemPrice(newPrice: Int) {
        guard let selectedItem else { return }
        
        selectedItem.price = newPrice
        fetchItems()
    }
    
    func deleteItem() {
        guard let modelContext, let selectedItem else { return }
        
        modelContext.delete(selectedItem)
        fetchItems()
    }
    
    func openItemDetailView() {
        isItemDetailSheetPresented = true
    }
    
    func openRestockView() {
        isRestockViewPresented = true
    }
    
    func openAddItemView() {
        isAddItemViewPresented = true
    }
}
