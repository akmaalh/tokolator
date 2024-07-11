//
//  Transaction.swift
//  tokolator
//
//  Created by Akmal Hakim on 12/07/24.
//
import SwiftUI
import Foundation
import SwiftData

@Model
class Restock {
    var id: UUID
    var itemId: UUID
    var quantity: Int
    var buyPrice: Int
    var date: Date

    init(itemId: UUID, quantity: Int, buyPrice: Int) {
        self.id = UUID()
        self.itemId = itemId
        self.quantity = quantity
        self.buyPrice = buyPrice
        self.date = Date()
    }
}

@Model
class Transaction {
    var date: Date
    var details: [TransactionDetail]
    var type: TransactionType

    init(type: TransactionType, date: Date) {
        self.date = date
        self.details = []
        self.type = type
    }
}

@Model
class TransactionDetail {
    var id: UUID
    var itemId: UUID
    var itemName: String
    var quantity: Int
    var price: Int
    var type: TransactionType

    init(itemId: UUID, itemName: String, quantity: Int, price: Int, type: TransactionType) {
        self.id = UUID()
        self.itemId = itemId
        self.itemName = itemName
        self.quantity = quantity
        self.price = price
        self.type = type
    }
}

enum TransactionType: String, Codable {
    case income
    case expense
}
