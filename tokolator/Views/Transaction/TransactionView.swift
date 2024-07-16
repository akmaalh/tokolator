//
//  TransactionView.swift
//  tokolator
//
//  Created by Akmal Hakim on 11/07/24.
//


import SwiftUI
import SwiftData

struct TransactionView: View {
//     @Query private var transactions: [Transaction]
    @StateObject private var viewModel: TransactionViewModel
    @State private var selectedDate = Date()
    @State private var showMonthPicker = false
    @State private var selectedSegment = TransactionType.income
    
    @Environment(\.modelContext) private var modelContext
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: TransactionViewModel(modelContext: modelContext))
    }

    private var dailySales: [DailySale] {
        viewModel.getDailySales(for: selectedDate, type: selectedSegment)
    }

    private var totalMonthlySales: Int {
        viewModel.getTotalMonthlySales(for: selectedDate, type: selectedSegment)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectedSegment, label: Text("Picker")) {
                    Text("Income").tag(TransactionType.income)
                    Text("Expenses").tag(TransactionType.expense)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                
                MonthPickerView(selectedDate: $selectedDate, showMonthPicker: $showMonthPicker)
                    .padding(.leading, 16.0)
                
                ScrollView {
                    ForEach(dailySales, id: \.date) { sale in
                        DailySalesRow(sale: sale, transactionType: selectedSegment)
                            .padding(.horizontal, 16.0)
                    }
                }
                
                
                // Total view with ultra-thin material background
                VStack {
                    HStack(alignment: .center) {
                        Text("Total")
                        Spacer()
                        Text(formatPrice(totalMonthlySales))
                            .fontWeight(.black)
                            .foregroundColor(selectedSegment == .income ? Color.green : Color.red)
                    }
                    .padding(.horizontal, 24.0)
                    .padding(.vertical, 16)
                    .background(.ultraThinMaterial)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Transaction History")
            .onAppear {
                viewModel.refreshData()
            }
        }
    }
    
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return "Rp" + (formatter.string(from: NSNumber(value: price)) ?? "\(price)")
    }
}

struct MonthPickerView: View {
    @Binding var selectedDate: Date
    @Binding var showMonthPicker: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            HStack(spacing: 8) {
                Text("Month: \(formattedMonth)")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            .padding(.all)
            .background(.ultraThinMaterial.opacity(0.7))
            .cornerRadius(10)
            Button(action: {
                showMonthPicker.toggle()
            }) {
                Image(systemName: "calendar")
                    .padding()
                    .background(Color.blue.opacity(0.3))
                    .cornerRadius(10)
            }
            .padding(.trailing)
        }
        .sheet(isPresented: $showMonthPicker) {
            MonthYearPickerView(selectedDate: $selectedDate)
        }
    }
    
    private var formattedMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
}
