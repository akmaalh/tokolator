//
//  CashierViewModel.swift
//  tokolator
//
//  Created by Akmal Hakim on 10/07/24.
//

import SwiftUI
import SwiftData

class CashierViewModel: ObservableObject {
    @Published var selectedItemCount: [UUID: Int] = [:]
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var showSummarySheet = false
    @Published var calculatedTotalHarga: Int = 0
    @Published var history: [(UUID, Int)] = []
    @Published var longPressedItem: Item?
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addItem(_ item: Item) {
        let currentCount = selectedItemCount[item.id] ?? 0
        if currentCount + 1 > item.stock {
            showAlert(message: "Jumlah melebihi stok yang tersedia. Stok \(item.name) tersedia: \(item.stock)")
        } else {
            updateItemCount(item, newCount: currentCount + 1)
        }
    }
    
    func updateItemCount(_ item: Item, newCount: Int) {
        if newCount > item.stock {
            showAlert(message: "Jumlah melebihi stok yang tersedia. Stok \(item.name) tersedia: \(item.stock)")
        } else {
            let oldCount = selectedItemCount[item.id] ?? 0
            let change = newCount - oldCount
            selectedItemCount[item.id] = newCount
            if change != 0 {
                history.append((item.id, change))
            }
            updateCalculatedTotalHarga()
        }
    }
    
    func updateCalculatedTotalHarga() {
        do {
            let itemsDescriptor = FetchDescriptor<Item>()
            let allItems = try modelContext.fetch(itemsDescriptor)
            
            calculatedTotalHarga = selectedItemCount.reduce(0) { total, pair in
                if let item = allItems.first(where: { $0.id == pair.key }) {
                    return total + pair.value * item.price
                }
                return total
            }
        } catch {
            print("Error fetching items: \(error)")
            calculatedTotalHarga = 0
        }
    }
    
    func clearSelection() {
        selectedItemCount = [:]
        history = []
        calculatedTotalHarga = 0
    }
    
    func decrementSelection() {
        guard let lastChange = history.last else {
            showAlert(message: "Tidak ada item untuk di-undo.")
            return
        }
        
        let (itemId, change) = lastChange
        if var currentCount = selectedItemCount[itemId] {
            currentCount -= change
            if currentCount <= 0 {
                selectedItemCount.removeValue(forKey: itemId)
            } else {
                selectedItemCount[itemId] = currentCount
            }
        }
        history.removeLast()
        updateCalculatedTotalHarga()
    }
    
    func calculateTotalPrice() {
        let totalSelectedCount = selectedItemCount.values.reduce(0, +)
        if totalSelectedCount == 0 {
            showAlert(message: "Anda belum memilih item.")
        } else {
            showSummarySheet = true
        }
    }
    
    func updateStock() {
        for (itemId, count) in selectedItemCount {
            if let item = try? modelContext.fetch(FetchDescriptor<Item>(predicate: #Predicate { $0.id == itemId })).first {
                item.stock -= count
            }
        }
        updateCalculatedTotalHarga()
    }
    
    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    func saveTransaction(_ transactionDetails: [TransactionDetail]) {
        for detail in transactionDetails {
            let transaction = Transaction(detail: detail)
            modelContext.insert(transaction)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving transaction: \(error)")
        }
    }
}
