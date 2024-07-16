//
//  SummarySheet.swift
//  tokolator
//
//  Created by Rangga Biner on 13/07/24.
//

import SwiftUI

struct SummarySheet: View {
    let selectedItems: [Item]
    let selectedItemCount: [UUID: Int]
    let totalHarga: Int
    var onSave: () -> Void
    var onCancel: () -> Void
    var onClear: () -> Void
    var onSaveTransaction: ([TransactionDetail]) -> Void
    
    @State private var showAlert = false
    @AppStorage("todayTransactionCount") private var todayTransactionCount: Int = 1
    @AppStorage("lastTransactionDate") private var lastTransactionDateTimeInterval: Double = Date().timeIntervalSince1970
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 20) {
                VStack (alignment: .leading, spacing: 8) {
                    Text(Date().formatted(.dateTime.weekday().day().month().year()))
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.top, 27)
                        .padding(.bottom, 37)
                    
                    Text("#\(todayTransactionCount) Transaction")
                        .font(.system(size: 20, weight: .medium))
                        .padding(.bottom, 37)
                    
                    ScrollView {
                        ForEach(selectedItems) { item in
                            if let count = selectedItemCount[item.id], count > 0 {
                                HStack {
                                    Text("\(count)x")
                                        .frame(width: 50, alignment: .leading)
                                    Text(item.name)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    Text("Rp \(count * item.price)")
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                }
                                .font(.system(size: 20, weight: .regular))
                            }
                        }
                        
                        HStack {
                            Text("Total Rp \(totalHarga)")
                                .font(.system(size: 20, weight: .medium))
                            Spacer()
                        }
                        .padding(.top, 37)
                        Spacer()
                    }
                }
                .padding(.horizontal, 22    )
                Spacer()
                HStack(spacing: 23) {
                    Button(action: {
                        onCancel()
                        dismiss()
                    }) {
                        Label("CANCEL", systemImage: "xmark.circle")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 20, weight: .regular))
                    }
                    .buttonStyle(CustomButtonStyle(color: .red))
                    
                    Button(action: {
                        let transactionDetails = createTransactionDetails()
                        onSaveTransaction(transactionDetails)
                        onSave()
                        showAlert = true
                    }) {
                        Label("SAVE", systemImage: "checkmark.circle")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 20, weight: .regular))
                    }
                    .buttonStyle(CustomButtonStyle(color: .green))
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 64)
                
            }
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 30))
                    .padding(14)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Your input have been saved!").font(.system(size: 17, weight: .semibold)),
                dismissButton: .default(Text("Continue").font(.system(size: 17, weight: .semibold)), action: {
                    onCancel()
                    dismiss()
                    onClear()
                    updateTransactionCount()
                })
            )
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .onAppear {
            checkAndResetDailyCount()
        }
        
    }
    
    private func createTransactionDetails() -> [TransactionDetail] {
        selectedItems.compactMap { item in
            guard let count = selectedItemCount[item.id], count > 0 else { return nil }
            return TransactionDetail(
                itemId: item.id,
                itemName: item.name,
                quantity: count,
                price: item.price,
                type: .income
            )
        }
    }
    
    private func updateTransactionCount() {
        checkAndResetDailyCount()
        todayTransactionCount += 1
        lastTransactionDateTimeInterval = Date().timeIntervalSince1970
    }
    private func checkAndResetDailyCount() {
        let calendar = Calendar.current
        let lastDate = Date(timeIntervalSince1970: lastTransactionDateTimeInterval)
        if !calendar.isDate(lastDate, inSameDayAs: Date()) {
            todayTransactionCount = 1
        }
    }
}

