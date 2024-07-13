//
//  TransactionViewModel.swift
//  tokolator
//
//  Created by Akmal Hakim on 12/07/24.
//

// TransactionViewModel.swift

import SwiftUI
import SwiftData


//class ItemViewModel: ObservableObject {
//    @Published var items: [Item] = []
//
//    init(context: ModelContext) {
//        // Initialize with context if needed
//    }
//
//    func addItem(name: String, price: Int) {
//        let newItem = Item(name: name, price: price)
//        items.append(newItem)
//    }
//
//    func updateStock(itemId: UUID, quantity: Int) {
//        if let index = items.firstIndex(where: { $0.id == itemId }) {
//            items[index].stock += quantity
//        }
//    }
//}
//
//class RestockViewModel: ObservableObject {
//    @Published var restocks: [Restock] = []
//    @ObservedObject var itemViewModel: ItemViewModel
//
//    init(itemViewModel: ItemViewModel) {
//        self.itemViewModel = itemViewModel
//    }
//
//    func restockItem(itemId: UUID, quantity: Int, buyPrice: Int) {
//        let newRestock = Restock(itemId: itemId, quantity: quantity, buyPrice: buyPrice)
//        restocks.append(newRestock)
//        itemViewModel.updateStock(itemId: itemId, quantity: quantity)
//    }
//}
//
//class TransactionViewModel: ObservableObject {
//    @Published var transactions: [Transaction] = []
//    private var context: ModelContext
//
//    init(context: ModelContext) {
//        self.context = context
//    }
//
//    func fetchTransactions(for date: Date, type: TransactionType) {
//        // Fetch transactions for the specified date and type
//        // For simplicity, we will just create a dummy transaction
//        let transaction = Transaction(type: type, date:date)
//        transactions = [transaction]
//    }
//
//    func recordTransaction(itemId: UUID, itemName: String, quantity: Int, price: Int, type: TransactionType) {
//        let today = Calendar.current.startOfDay(for: Date())
//
//        if let transaction = transactions.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
//            let detail = TransactionDetail(itemId: itemId, itemName: itemName, quantity: quantity, price: price, type: type)
//            transaction.details.append(detail)
//        } else {
//            let newTransaction = Transaction(type: type, date: today)
//            let detail = TransactionDetail(itemId: itemId, itemName: itemName, quantity: quantity, price: price, type: type)
//            newTransaction.details.append(detail)
//            transactions.append(newTransaction)
//        }
//    }
//
//    func getDailySummary(date: Date) -> (income: Int, expense: Int) {
//        let filteredTransactions = transactions.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
//        var income = 0
//        var expense = 0
//
//        for transaction in filteredTransactions {
//            for detail in transaction.details {
//                switch detail.type {
//                case .income:
//                    income += detail.price * detail.quantity
//                case .expense:
//                    expense += detail.price * detail.quantity
//                }
//            }
//        }
//
//        return (income, expense)
//    }
//    
//    private func generateDummyData() {
//        let calendar = Calendar.current
//        let today = Date()
//        for monthOffset in 0..<3 {
//            for dayOffset in 0..<20 {
//                let date = calendar.date(byAdding: .day, value: -dayOffset, to: calendar.date(byAdding: .month, value: -monthOffset, to: today)!)!
//                let incomeTransaction = Transaction(type: .income, date: date)
//                let expenseTransaction = Transaction(type: .expense, date: date)
//                
//                let detail1 = TransactionDetail(itemId: UUID(), itemName: "Item \(monthOffset * 20 + dayOffset)", quantity: Int.random(in: 1...10), price: Int.random(in: 1000...5000), type: .income)
//                let detail2 = TransactionDetail(itemId: UUID(), itemName: "Item \(monthOffset * 20 + dayOffset)", quantity: Int.random(in: 1...10), price: Int.random(in: 1000...5000), type: .expense)
//                
//                incomeTransaction.details.append(detail1)
//                expenseTransaction.details.append(detail2)
//                
//                transactions.append(incomeTransaction)
//                transactions.append(expenseTransaction)
//            }
//        }
//    }
//}
