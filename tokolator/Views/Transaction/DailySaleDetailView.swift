//
//  DailySaleDetailView.swift
//  tokolator
//
//  Created by Akmal Hakim on 15/07/24.
//

import Foundation
import SwiftUI

struct DailySaleDetailView: View {
    let sale: DailySale
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(formattedDate)")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 8)
            
            
            if color == .green {
                Text("Income History")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.leading, 24)
            } else if color == .red {
                Text("Expense History")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.leading, 24)
            }
            
            List {
                if color == .green { // Assuming color == .green indicates income, hence showing top items
                    Section(header: Text("Top 3 bought items")) {
                        ForEach(Array(groupedTransactions.sorted { $0.totalQuantity > $1.totalQuantity }.prefix(3).enumerated()), id: \.element.itemName) { index, group in
                            HStack {
                                Text("\(group.itemName)")
                                Spacer()
                                Text("x\(group.totalQuantity)")
                                Text("\(formatPrice(group.totalPrice))")
                            }
                        }
                    }
                    
                    Section(header: Text("Others")) {
                        ForEach(Array(groupedTransactions.sorted { $0.totalQuantity > $1.totalQuantity }.dropFirst(3).enumerated()), id: \.element.itemName) { index, group in
                            HStack {
                                Text("\(group.itemName)")
                                Spacer()
                                Text("x\(group.totalQuantity)")
                                Text("\(formatPrice(group.totalPrice))")
                            }
                        }
                    }
                } else {
                    // For transactions not marked as income (color != .green), list all items without highlighting
                    ForEach(groupedTransactions.sorted { $0.totalQuantity > $1.totalQuantity }, id: \.itemName) { group in
                        HStack {
                            Text("\(group.itemName)")
                            Spacer()
                            Text("x\(group.totalQuantity)")
                            Text("\(formatPrice(group.totalPrice))")
                        }
                    }
                }
            }
            
            HStack {
                Text("Subtotal")
                Spacer()
                Text("\(formatPrice(sale.totalSales))")
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yyyy"
        return formatter.string(from: sale.date)
    }
    
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return "Rp" + (formatter.string(from: NSNumber(value: price)) ?? "\(price)")
    }
    
    private var groupedTransactions: [GroupedTransaction] {
        Dictionary(grouping: sale.transactions, by: { $0.itemName })
            .map { itemName, transactions in
                let totalQuantity = transactions.reduce(0) { $0 + $1.quantity }
                let totalPrice = transactions.reduce(0) { $0 + ($1.quantity * $1.price) }
                return GroupedTransaction(itemName: itemName, totalQuantity: totalQuantity, totalPrice: totalPrice)
            }
            .sorted { $0.itemName < $1.itemName }
    }
}
