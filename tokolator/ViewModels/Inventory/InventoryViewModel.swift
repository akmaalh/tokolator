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
    
    func restockItems(restockViewModel: RestockViewModel) {
        guard let modelContext else { return }
        
        for restockItem in restockViewModel.restockItems {
            if let itemId = restockItem.itemId,
               let quantity = restockItem.quantity,
               let price = restockItem.price,
               let itemIndex = items.firstIndex(where: { $0.id == itemId }) {
                let item = items[itemIndex]
                
                item.stock += quantity
                
                let transactionDetail = TransactionDetail(itemId: item.id, itemName: item.name, quantity: quantity, price: price, type: .expense)
                
                modelContext.insert(transactionDetail)
                
                let transaction = Transaction(detail: transactionDetail)
                
                modelContext.insert(transaction)
            }
        }
        
        restockViewModel.showAlert = true
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
