import SwiftUI
import SwiftData

@Observable
class RestockViewModel {
    var restockItems: [RestockItem]
    var showAlert: Bool
    
    init() {
        restockItems = []
        showAlert = false
    }
    
    func checkForm() -> Bool {
        for item in restockItems {
            if item.itemId == nil || item.quantity == nil || item.price == nil {
                return false
            }
        }
        return true
    }
}
