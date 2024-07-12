//
//  DailyCardView.swift
//  tokolator
//
//  Created by Akmal Hakim on 11/07/24.
//

import SwiftUI

struct DailyCardView: View {
    let transaction: Transaction
    var body: some View {
        HStack(alignment: .center) {
            Text(transaction.date, style: .date)
            Spacer()
            Text("Rp\(transaction.details.reduce(0) { $0 + $1.price * $1.quantity })")
                .fontWeight(.black)
                .foregroundColor(transaction.type == .income ? .green : .red)
        }
        .padding(.all, 24.0)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                . inset(by: 1)
                .stroke(.strokeClr, lineWidth: 2))
        
    }
}

//struct DailyCardView: View {
//    let transaction: Transaction
//    
//    var body: some View {
//        HStack(alignment: .center) {
//            VStack(alignment: .leading) {
//                Text(transaction.date, style: .date)
//                    .font(.headline)
//            }
//            Spacer()
//            Text("Rp\(transaction.details.reduce(0) { $0 + $1.price * $1.quantity })")
//                .fontWeight(.bold)
//                .foregroundColor(transaction.type == .income ? .green : .red)
//        }
//        .padding(.all, 16)
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
//    }
//}
