import SwiftUI
import SwiftData

class InventoryViewModel: ObservableObject {
    @Query(sort: \Item.timestamp, order: .reverse) var items: [Item]
    @Published var selectedItem: Item?
    @Published var isRestockViewPresented: Bool = false
    @Published var isAddItemViewPresented: Bool = false
    
    func openRestockView() {
        isRestockViewPresented = true
    }
    
    func openAddItemView() {
        isAddItemViewPresented = true
    }
}
