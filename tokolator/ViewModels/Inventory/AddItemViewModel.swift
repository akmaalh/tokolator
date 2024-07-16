import SwiftUI
import SwiftData
import PhotosUI

@Observable
class AddItemViewModel {
    var name: String
    var price: String
    var selectedPhoto: PhotosPickerItem?
    var selectedPhotoData: Data?
    var showAlert: Bool
    
    init() {
        name = ""
        price = ""
        selectedPhoto = nil
        selectedPhotoData = nil
        showAlert = false
    }
    
    func checkForm() -> Bool {
        if (name.isEmpty || price.isEmpty || selectedPhoto == nil) {
            return false
        } else {
            return true
        }
    }
}
