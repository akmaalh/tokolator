//
//  Util.swift
//  tokolator
//
//  Created by Akmal Hakim on 10/07/24.
//

import Foundation
import SwiftData

class DummyDataGenerator {
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func generateDummyTransactions() {
        let calendar = Calendar.current
        let now = Date()
        var dateComponents = DateComponents()

        for monthOffset in stride(from: -12, through: -3, by: 3) {
            dateComponents.month = monthOffset
            guard let startDate = calendar.date(byAdding: dateComponents, to: now) else { continue }
            
            for _ in 0..<20 {
                guard let randomDate = calendar.date(byAdding: .day, value: Int.random(in: 0...90), to: startDate) else { continue }
                
                let transactionDetail = TransactionDetail(
                    itemId: UUID(),
                    itemName: "Dummy Item",
                    quantity: Int.random(in: 1...10),
                    price: Int.random(in: 1000...10000),
                    type: .income
                )
                
                let transaction = Transaction(detail: transactionDetail, timestamp: randomDate)
                modelContext.insert(transaction)
            }
        }

        do {
            try modelContext.save()
        } catch {
            print("Error saving dummy transactions: \(error)")
        }
    }
}
