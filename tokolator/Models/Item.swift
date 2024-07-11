import SwiftUI
import SwiftData

@Model
class Item {
    var timestamp: Date
    var id: UUID
    var name: String
    var stock: Int
    var price: Int
    
    @Attribute(.externalStorage) var image: Data?
    
    init(name: String = "", price: Int = 0) {
        self.timestamp = Date()
        self.id = UUID()
        self.name = name
        self.stock = 0
        self.price = price
    }
}



