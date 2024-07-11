//
//  TransactionView.swift
//  tokolator
//
//  Created by Akmal Hakim on 11/07/24.
//

import SwiftUI
import SwiftData

struct TransactionView: View {
    @Environment(\.modelContext) private var context
    @State private var selectedDate = Date()
    @State private var isMonthPickerPresented = false
    @State private var isDailyDetailsPresented = false
    @State private var selectedSegment = TransactionType.income
    @State private var selectedTransaction: Transaction?

    @StateObject private var transactionViewModel: TransactionViewModel
    @StateObject private var itemViewModel: ItemViewModel

    init() {
        let container = try! ModelContainer(for: Transaction.self, Item.self, TransactionDetail.self)
        let context = container.mainContext
        _transactionViewModel = StateObject(wrappedValue: TransactionViewModel(context: context))
        _itemViewModel = StateObject(wrappedValue: ItemViewModel(context: context))
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Picker(selection: $selectedSegment, label: Text("Picker")) {
                    Text("Income").tag(TransactionType.income)
                    Text("Expenses").tag(TransactionType.expense)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .onChange(of: selectedSegment) { _ in
                    transactionViewModel.fetchTransactions(for: selectedDate, type: selectedSegment)
                }

                Button(action: {
                    isMonthPickerPresented = true
                }) {
                    Text("Selected: \(formattedDate)")
                        .foregroundColor(.blue)
                        .padding(.vertical)
                }
                .sheet(isPresented: $isMonthPickerPresented) {
                    VStack {
                        YearMonthPicker(date: $selectedDate, startYear: 2000, endYear: 2024)
                        Button("Submit") {
                            isMonthPickerPresented = false
                            transactionViewModel.fetchTransactions(for: selectedDate, type: selectedSegment)
                        }
                    }
                    .presentationDetents([.height(250)])
                }

                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(transactionViewModel.transactions) { transaction in
                            DailyCardView(transaction: transaction)
                                .onTapGesture {
                                    selectedTransaction = transaction
                                    isDailyDetailsPresented = true
                                }
                        }
                        ForEach(0..<10) { _ in
                            DailyCardView(transaction: Transaction(type: .income, date:Date()))
                                .onTapGesture {
                                    selectedTransaction = Transaction(type: .income, date:Date())
                                    isDailyDetailsPresented = true
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 90) // Add extra padding at the bottom to account for the total view
                }
            }

            // Total view with ultra-thin material background
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Text("Total")
                    Spacer()
                    Text("Rp\(totalAmount)")
                        .fontWeight(.black)
                        .foregroundColor(selectedSegment == .income ? Color.green : Color.red)
                }
                .padding(.horizontal, 24.0)
                .padding(.vertical, 16)
                .background(.ultraThinMaterial)
                .frame(maxWidth: .infinity)
            }
        }
        .sheet(item: $selectedTransaction) { transaction in
            DailyDetailsView(transaction: transaction, itemViewModel: itemViewModel)
        }
        .onAppear {
            transactionViewModel.fetchTransactions(for: selectedDate, type: selectedSegment)
        }
    }

    var totalAmount: Int {
        transactionViewModel.transactions.reduce(0) { $0 + $1.details.reduce(0) { $0 + $1.price * $1.quantity } }
    }
}

struct DailyDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    let transaction: Transaction
    let itemViewModel: ItemViewModel

    var body: some View {
        NavigationView {
            VStack {
                Text(transaction.date, style: .date)
                    .font(.headline)
                    .padding()

                List(transaction.details) { detail in
                    if let item = itemViewModel.items.first(where: { $0.id == detail.itemId }) {
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("x\(detail.quantity)")
                            Text("Rp\(detail.price)")
                        }
                    }
                }

                HStack {
                    Text("Grand Total")
                    Spacer()
                    Text("Rp\(grandTotal)")
                        .fontWeight(.bold)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
            }
            .navigationBarTitle("Transaction Details", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
        }
    }

    var grandTotal: Int {
        transaction.details.reduce(0) { $0 + $1.price * $1.quantity }
    }
}

#Preview {
    TransactionView()
}
