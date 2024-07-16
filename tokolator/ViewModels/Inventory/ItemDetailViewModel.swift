import SwiftUI
import SwiftData
import PhotosUI

@Observable
class ItemDetailViewModel {
    var price: String
    var isPriceChanged: Bool
    var showSaveAlert: Bool
    var showDeleteConfirmationDialog: Bool
    var confirmedToDelete: Bool
    
    init() {
        price = ""
        isPriceChanged = false
        showSaveAlert = false
        showDeleteConfirmationDialog = false
        confirmedToDelete = false
    }
}
