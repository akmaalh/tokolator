//
//  DailyCardView.swift
//  tokolator
//
//  Created by Akmal Hakim on 11/07/24.
//

import SwiftUI

struct DailySalesRow: View {
    let sale: DailySale
    @State private var showDetail = false
    var transactionType: TransactionType
    
    var foregroundColor: Color {
        switch transactionType {
        case .income:
            return .green
        case .expense:
            return .red
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(formattedDate)
            Spacer()
            Text("\(formatPrice(sale.totalSales))")
                .fontWeight(.black)
                .foregroundColor(foregroundColor)
        }
        .padding(.all, 24.0)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .onTapGesture {
            showDetail = true
        }
        .sheet(isPresented: $showDetail) {
            DailySaleDetailView(sale: sale, color: foregroundColor)
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: sale.date)
    }
    
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return "Rp" + (formatter.string(from: NSNumber(value: price)) ?? "\(price)")
    }
}
