//
//  TransactionViewModel.swift
//  tokolator
//
//  Created by Akmal Hakim on 12/07/24.
//

// TransactionViewModel.swift
import Foundation
import SwiftData

@Observable
class TransactionViewModel: ObservableObject {
    @MainActor
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @MainActor
    func fetchTransactions() -> [Transaction] {
        let descriptor = FetchDescriptor<Transaction>()
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching transactions: \(error)")
            return []
        }
    }
    
    func getFilteredTransactions(for date: Date, type: TransactionType) -> [Transaction] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let startOfMonth = calendar.date(from: components),
              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
            print("Error calculating date range")
            return []
        }
        
        let descriptor = FetchDescriptor<Transaction>()
        do {
            let fetchedTransactions = try modelContext.fetch(descriptor)
            return fetchedTransactions.filter {
                transaction in let isWithinDateRange = transaction.timestamp >= startOfMonth && transaction.timestamp <= endOfMonth
                let isCorrectType = transaction.type == type
                return isWithinDateRange && isCorrectType
            }
        } catch {
            print("Error fetching filtered transactions: \(error)")
            return []
        }
    }
    
    func getDailySales(for date: Date, type: TransactionType) -> [DailySale] {
        let transactions = getFilteredTransactions(for: date, type: type)
        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: transactions) { transaction in
            calendar.startOfDay(for: transaction.timestamp)
        }
        
        return groupedByDay.map { date, transactions in
            DailySale(date: date, transactions: transactions)
        }.sorted { $0.date < $1.date }
    }
    
    func getTotalMonthlySales(for date: Date, type: TransactionType) -> Int {
        let dailySales = getDailySales(for: date, type: type)
        return dailySales.reduce(0) { $0 + $1.totalSales }
    }
}
