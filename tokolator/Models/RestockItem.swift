import SwiftUI
import SwiftData

class RestockItem: Identifiable {
    var id: UUID
    var itemId: UUID?
    var quantity: Int?
    var price: Int?
    
    init(itemId: UUID? = nil) {
        self.id = UUID()
        self.itemId = itemId
        self.quantity = nil
        self.price = nil
    }
}
