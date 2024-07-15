//
//  TransactionView.swift
//  tokolator
//
//  Created by Akmal Hakim on 11/07/24.
//


import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct TransactionView: View {
    @Query private var transactions: [Transaction]
    @State private var searchText = ""
    @State private var selectedDate = Date()
    @State private var showMonthPicker = false
    @State private var selectedSegment = TransactionType.income

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
                    Spacer()
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
            .searchable(text: $searchText, prompt: "Search transactions")
        }
    }
    
    private var filteredTransactions: [Transaction] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        let startOfMonth = calendar.date(from: components)!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        return transactions.filter { transaction in
            let matchesDate = transaction.timestamp >= startOfMonth && transaction.timestamp <= endOfMonth
            let matchesSearch = searchText.isEmpty || transaction.itemName.localizedCaseInsensitiveContains(searchText)
            let matchesType = transaction.type == selectedSegment
            return matchesDate && matchesSearch && matchesType
        }
    }
    
    private var dailySales: [DailySale] {
        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: filteredTransactions) { transaction in
            calendar.startOfDay(for: transaction.timestamp)
        }
        return groupedByDay.map { date, transactions in
            DailySale(date: date, transactions: transactions)
        }.sorted { $0.date < $1.date }
    }
    
    private var totalMonthlySales: Int {
        dailySales.reduce(0) { $0 + $1.totalSales }
    }
    
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return "Rp" + (formatter.string(from: NSNumber(value: price)) ?? "\(price)")
    }
}

struct DailySale: Identifiable {
    let id = UUID()
    let date: Date
    let transactions: [Transaction]
    
    var totalSales: Int {
        transactions.reduce(0) { $0 + ($1.quantity * $1.price) }
    }
}

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
            Text("Rp\(formatPrice(sale.totalSales))")
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
            DailySaleDetailView(sale: sale)
        }
    }
    
//    var body: some View {
//        HStack {
//            Text(formattedDate)
//                .font(.headline)
//            Spacer()
//            Text(formatPrice(sale.totalSales))
//                .font(.subheadline)
//        }
//        .contentShape(Rectangle())
//        .onTapGesture {
//            showDetail = true
//        }
//        .sheet(isPresented: $showDetail) {
//            DailySaleDetailView(sale: sale)
//        }
//    }
    
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

struct MonthPickerView: View {
    @Binding var selectedDate: Date
    @Binding var showMonthPicker: Bool
    
    var body: some View {
        HStack {
            Text("Month: \(formattedMonth)")
            Spacer()
            Button(action: {
                showMonthPicker.toggle()
            }) {
                Image(systemName: "calendar")
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
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

struct MonthYearPickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedMonth = 0
    @State private var selectedYear = 0
    
    let months = Calendar.current.monthSymbols
    let years = Array(1900...2100)
    
    var body: some View {
        VStack {
            HStack {
                Picker("Month", selection: $selectedMonth) {
                    ForEach(0..<months.count, id: \.self) { index in
                        Text(months[index]).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 150)
                
                Picker("Year", selection: $selectedYear) {
                    ForEach(0..<years.count, id: \.self) { index in
                        Text(String(years[index])).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
            }
            .padding()
            
            Button("Done") {
                updateSelectedDate()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .onAppear {
            initializeSelection()
        }
    }
    
    private func initializeSelection() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: selectedDate)
        selectedMonth = (components.month ?? 1) - 1
        selectedYear = years.firstIndex(of: components.year ?? 2000) ?? 0
    }
    
    private func updateSelectedDate() {
        var components = DateComponents()
        components.month = selectedMonth + 1
        components.year = years[selectedYear]
        if let newDate = Calendar.current.date(from: components) {
            selectedDate = newDate
        }
    }
}

struct DailySaleDetailView: View {
    let sale: DailySale
    
    var body: some View {
        VStack {
            Text("Tanggal: \(formattedDate)")
                .font(.headline)
                .padding()
            
            List(groupedTransactions, id: \.itemName) { group in
                HStack {
                    Text("\(group.itemName)")
                    Spacer()
                    Text("x\(group.totalQuantity)")
                    Text("Rp\(formatPrice(group.totalPrice))")
                }
            }
            
            HStack {
                Text("Total Penjualan")
                Spacer()
                Text("\(formatPrice(sale.totalSales))")
                    .fontWeight(.bold)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
        }
    }
    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Tanggal: \(formattedDate)")
//                .font(.headline)
//                .padding(.bottom)
//            
//            ForEach(groupedTransactions, id: \.itemName) { group in
//                VStack(alignment: .leading) {
//                    Text("\(group.itemName)")
//                    Text("  Total terjual \(group.totalQuantity)")
//                    Text("  Total price: \(formatPrice(group.totalPrice))")
//                }
//                .padding(.bottom, 5)
//            }
//            
//            Divider()
//            
//            HStack {
//                Text("Total Penjualan:")
//                    .font(.headline)
//                Spacer()
//                Text(formatPrice(sale.totalSales))
//                    .font(.headline)
//            }
//        }
//        .padding()
//    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
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

struct GroupedTransaction {
    let itemName: String
    let totalQuantity: Int
    let totalPrice: Int
}

#Preview {
    TransactionView()
}

//struct TransactionView: View {
//    @Query private var transactions: [Transaction]
//    @State private var searchText = ""
//    @State private var selectedDate = Date()
//    @State private var showMonthPicker = false
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                MonthPickerView(selectedDate: $selectedDate, showMonthPicker: $showMonthPicker)
//                
//                List {
//                    ForEach(dailySales, id: \.date) { sale in
//                        DailySalesRow(sale: sale)
//                    }
//                }
//            }
//            .navigationTitle("Transaction History")
//            .searchable(text: $searchText, prompt: "Search transactions")
//        }
//    }
//    
//    private var filteredTransactions: [Transaction] {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month], from: selectedDate)
//        let startOfMonth = calendar.date(from: components)!
//        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
//        
//        return transactions.filter { transaction in
//            let matchesDate = transaction.timestamp >= startOfMonth && transaction.timestamp <= endOfMonth
//            let matchesSearch = searchText.isEmpty || transaction.itemName.localizedCaseInsensitiveContains(searchText)
//            return matchesDate && matchesSearch
//        }
//    }
//    
//    private var dailySales: [DailySale] {
//        let calendar = Calendar.current
//        let groupedByDay = Dictionary(grouping: filteredTransactions) { transaction in
//            calendar.startOfDay(for: transaction.timestamp)
//        }
//        return groupedByDay.map { date, transactions in
//            DailySale(date: date, transactions: transactions)
//        }.sorted { $0.date < $1.date }
//    }
//    
//    private var totalMonthlySales: Int {
//        dailySales.reduce(0) { $0 + $1.totalSales }
//    }
//}
//
//struct DailySale: Identifiable {
//    let id = UUID()
//    let date: Date
//    let transactions: [Transaction]
//    
//    var totalSales: Int {
//        transactions.reduce(0) { $0 + ($1.quantity * $1.price) }
//    }
//}
//
//struct DailySalesRow: View {
//    let sale: DailySale
//    @State private var showDetail = false
//    
//    var body: some View {
//        HStack {
//            Text(formattedDate)
//                .font(.headline)
//            Spacer()
//            Text(formatPrice(sale.totalSales))
//                .font(.subheadline)
//        }
//        .contentShape(Rectangle())
//        .onTapGesture {
//            showDetail = true
//        }
//        .sheet(isPresented: $showDetail) {
//            DailySaleDetailView(sale: sale)
//        }
//    }
//    
//    private var formattedDate: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE, d MMMM"
//        return formatter.string(from: sale.date)
//    }
//    
//    private func formatPrice(_ price: Int) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.groupingSeparator = "."
//        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
//    }
//}
//
//struct MonthPickerView: View {
//    @Binding var selectedDate: Date
//    @Binding var showMonthPicker: Bool
//    
//    var body: some View {
//        HStack {
//            Text("Month: \(formattedMonth)")
//            Spacer()
//            Button(action: {
//                showMonthPicker.toggle()
//            }) {
//                Image(systemName: "calendar")
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(10)
//            }
//            .padding(.horizontal)
//        }
//        .sheet(isPresented: $showMonthPicker) {
//            MonthYearPickerView(selectedDate: $selectedDate)
//        }
//    }
//    
//    private var formattedMonth: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM yyyy"
//        return formatter.string(from: selectedDate)
//    }
//}
//
//struct MonthYearPickerView: View {
//    @Binding var selectedDate: Date
//    @Environment(\.presentationMode) var presentationMode
//    @State private var selectedMonth = 0
//    @State private var selectedYear = 0
//    
//    let months = Calendar.current.monthSymbols
//    let years = Array(1900...2100)
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Picker("Month", selection: $selectedMonth) {
//                    ForEach(0..<months.count, id: \.self) { index in
//                        Text(months[index]).tag(index)
//                    }
//                }
//                .pickerStyle(WheelPickerStyle())
//                .frame(width: 150)
//                
//                Picker("Year", selection: $selectedYear) {
//                    ForEach(0..<years.count, id: \.self) { index in
//                        Text(String(years[index])).tag(index)
//                    }
//                }
//                .pickerStyle(WheelPickerStyle())
//                .frame(width: 100)
//            }
//            .padding()
//            
//            Button("Done") {
//                updateSelectedDate()
//                presentationMode.wrappedValue.dismiss()
//            }
//            .padding()
//        }
//        .onAppear {
//            initializeSelection()
//        }
//    }
//    
//    private func initializeSelection() {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.month, .year], from: selectedDate)
//        selectedMonth = (components.month ?? 1) - 1
//        selectedYear = years.firstIndex(of: components.year ?? 2000) ?? 0
//    }
//    
//    private func updateSelectedDate() {
//        var components = DateComponents()
//        components.month = selectedMonth + 1
//        components.year = years[selectedYear]
//        if let newDate = Calendar.current.date(from: components) {
//            selectedDate = newDate
//        }
//    }
//}
//struct DailySaleDetailView: View {
//    let sale: DailySale
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Tanggal: \(formattedDate)")
//                .font(.headline)
//                .padding(.bottom)
//            
//            ForEach(groupedTransactions, id: \.itemName) { group in
//                VStack(alignment: .leading) {
//                    Text("\(group.itemName)")
//                    Text("  Total terjual \(group.totalQuantity)")
//                    Text("  Total price: \(formatPrice(group.totalPrice))")
//                }
//                .padding(.bottom, 5)
//            }
//            
//            Divider()
//            
//            HStack {
//                Text("Total Penjualan:")
//                    .font(.headline)
//                Spacer()
//                Text(formatPrice(sale.totalSales))
//                    .font(.headline)
//            }
//        }
//        .padding()
//    }
//    
//    private var formattedDate: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d MMM yyyy"
//        return formatter.string(from: sale.date)
//    }
//    
//    private func formatPrice(_ price: Int) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.groupingSeparator = "."
//        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
//    }
//    
//    private var groupedTransactions: [GroupedTransaction] {
//        Dictionary(grouping: sale.transactions, by: { $0.itemName })
//            .map { itemName, transactions in
//                let totalQuantity = transactions.reduce(0) { $0 + $1.quantity }
//                let totalPrice = transactions.reduce(0) { $0 + ($1.quantity * $1.price) }
//                return GroupedTransaction(itemName: itemName, totalQuantity: totalQuantity, totalPrice: totalPrice)
//            }
//            .sorted { $0.itemName < $1.itemName }
//    }
//}
//
//struct GroupedTransaction {
//    let itemName: String
//    let totalQuantity: Int
//    let totalPrice: Int
//}
//
//#Preview {
//    TransactionView()
//}


//struct TransactionView: View {
//    @Environment(\.modelContext) private var context
//    @State private var selectedDate = Date()
//    @State private var isMonthPickerPresented = false
//    @State private var isDailyDetailsPresented = false
//    @State private var selectedSegment = TransactionType.income
//    @State private var selectedTransaction: Transaction?
//
//    @StateObject private var transactionViewModel: TransactionViewModel
//    @StateObject private var itemViewModel: ItemViewModel
//
//    init() {
//        let container = try! ModelContainer(for: Transaction.self, Item.self, TransactionDetail.self)
//        let context = container.mainContext
//        _transactionViewModel = StateObject(wrappedValue: TransactionViewModel(context: context))
//        _itemViewModel = StateObject(wrappedValue: ItemViewModel(context: context))
//    }
//
//    var formattedDate: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM yyyy"
//        return formatter.string(from: selectedDate)
//    }
//
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            VStack(spacing: 0) {
//                Picker(selection: $selectedSegment, label: Text("Picker")) {
//                    Text("Income").tag(TransactionType.income)
//                    Text("Expenses").tag(TransactionType.expense)
//                }
//                .pickerStyle(.segmented)
//                .padding(.horizontal, 16)
//                .onChange(of: selectedSegment) { _ in
//                    transactionViewModel.fetchTransactions(for: selectedDate, type: selectedSegment)
//                }
//
//                Button(action: {
//                    isMonthPickerPresented = true
//                }) {
//                    Text("Selected: \(formattedDate)")
//                        .foregroundColor(.blue)
//                        .padding(.vertical)
//                }
//                .sheet(isPresented: $isMonthPickerPresented) {
//                    VStack {
//                        YearMonthPicker(date: $selectedDate, startYear: 2000, endYear: 2024)
//                        Button("Submit") {
//                            isMonthPickerPresented = false
//                            transactionViewModel.fetchTransactions(for: selectedDate, type: selectedSegment)
//                        }
//                    }
//                    .presentationDetents([.height(250)])
//                }
//
//                ScrollView {
//                    VStack(spacing: 8) {
//                        ForEach(transactionViewModel.transactions) { transaction in
//                            DailyCardView(transaction: transaction)
//                                .onTapGesture {
//                                    selectedTransaction = transaction
//                                    isDailyDetailsPresented = true
//                                }
//                        }
//                        ForEach(0..<10) { _ in
//                            DailyCardView(transaction: Transaction(type: .income, date:Date()))
//                                .onTapGesture {
//                                    selectedTransaction = Transaction(type: .income, date:Date())
//                                    isDailyDetailsPresented = true
//                                }
//                        }
//                    }
//                    .padding(.horizontal, 16)
//                    .padding(.bottom, 90) // Add extra padding at the bottom to account for the total view
//                }
//            }
//
//            // Total view with ultra-thin material background
//            VStack {
//                Spacer()
//                HStack(alignment: .center) {
//                    Text("Total")
//                    Spacer()
//                    Text("Rp\(totalAmount)")
//                        .fontWeight(.black)
//                        .foregroundColor(selectedSegment == .income ? Color.green : Color.red)
//                }
//                .padding(.horizontal, 24.0)
//                .padding(.vertical, 16)
//                .background(.ultraThinMaterial)
//                .frame(maxWidth: .infinity)
//            }
//        }
//        .sheet(item: $selectedTransaction) { transaction in
//            DailyDetailsView(transaction: transaction, itemViewModel: itemViewModel)
//        }
//        .onAppear {
//            transactionViewModel.fetchTransactions(for: selectedDate, type: selectedSegment)
//        }
//    }
//
//    var totalAmount: Int {
//        transactionViewModel.transactions.reduce(0) { $0 + $1.details.reduce(0) { $0 + $1.price * $1.quantity } }
//    }
//}
//
//struct DailyDetailsView: View {
//    @Environment(\.dismiss) private var dismiss
//    let transaction: Transaction
//    let itemViewModel: ItemViewModel
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text(transaction.date, style: .date)
//                    .font(.headline)
//                    .padding()
//
//                List(transaction.details) { detail in
//                    if let item = itemViewModel.items.first(where: { $0.id == detail.itemId }) {
//                        HStack {
//                            Text(item.name)
//                            Spacer()
//                            Text("x\(detail.quantity)")
//                            Text("Rp\(detail.price)")
//                        }
//                    }
//                }
//
//                HStack {
//                    Text("Grand Total")
//                    Spacer()
//                    Text("Rp\(grandTotal)")
//                        .fontWeight(.bold)
//                }
//                .padding()
//                .background(Color.gray.opacity(0.2))
//            }
//            .navigationBarTitle("Transaction Details", displayMode: .inline)
//            .navigationBarItems(trailing: Button("Close") {
//                dismiss()
//            })
//        }
//    }
//
//    var grandTotal: Int {
//        transaction.details.reduce(0) { $0 + $1.price * $1.quantity }
//    }
//}
//
//#Preview {
//    TransactionView()
//}
