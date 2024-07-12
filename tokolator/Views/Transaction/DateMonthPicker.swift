//
//  DateMonthPicker.swift
//  tokolator
//
//  Created by Akmal Hakim on 11/07/24.
//

import SwiftUI

struct YearMonthPicker: View {
    @Binding var date: Date
    @State private var selectedYear: Int
    @State private var selectedMonth: Int
    
    let startYear: Int
    let endYear: Int
    
    init(date: Binding<Date>, startYear: Int, endYear: Int) {
        self._date = date
        let calendar = Calendar.current
        self._selectedYear = State(initialValue: calendar.component(.year, from: date.wrappedValue))
        self._selectedMonth = State(initialValue: calendar.component(.month, from: date.wrappedValue))
        self.startYear = startYear
        self.endYear = endYear
    }
    
    var body: some View {
        HStack {
            Picker("Month", selection: $selectedMonth) {
                ForEach(1...12, id: \.self) { month in
                    Text(DateFormatter().monthSymbols[month - 1]).tag(month)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 150)
            .clipped()
            
            Picker("Year", selection: $selectedYear) {
                ForEach(startYear...endYear, id: \.self) { year in
                    Text(String(year)).tag(year)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100)
            .clipped()
        }
        .onChange(of: selectedMonth) { _ in updateDate() }
        .onChange(of: selectedYear) { _ in updateDate() }
    }
    
    private func updateDate() {
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        if let newDate = Calendar.current.date(from: components) {
            date = newDate
        }
    }
}
