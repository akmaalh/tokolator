//
//  SummarySheet.swift
//  tokolator
//
//  Created by Rangga Biner on 13/07/24.
//

import SwiftUI

struct SummarySheetView: View {
    let selectedItems: [Item]
    let selectedItemCount: [UUID: Int]
    let totalHarga: Int
    var onSave: () -> Void
    var onCancel: () -> Void
    var onClear: () -> Void
    var onSaveTransaction: ([TransactionDetail]) -> Void

    
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            List {
                ForEach(selectedItems) { item in
                    if let count = selectedItemCount[item.id], count > 0 {
                        VStack(alignment: .leading) {
                            Text("\(item.name)")
                            Text("Count: \(count)")
                            Text("Total Price: \(count * item.price)")
                        }
                    }
                }
            }
            Text("Total Harga Semua Item: \(totalHarga)")
                .font(.headline)
                .padding()
            HStack {
                Button(action: {
                    onCancel()
                }) {
                    Text("Cancel")
                        .font(.system(size: 20, weight: .bold))
                        .frame(width: 100, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    let transactionDetails = createTransactionDetails()
                    onSaveTransaction(transactionDetails)
                    onSave()
                    showAlert = true

                }) {
                    Text("Save")
                        .font(.system(size: 20, weight: .bold))
                        .frame(width: 100, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Success"),
                message: Text("Your input has been saved."),
                dismissButton: .default(Text("Continue"), action: {
                    onClear()
                    onCancel()
                })
            )
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
}
