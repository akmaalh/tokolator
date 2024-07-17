//
//  DateMonthPicker.swift
//  tokolator
//
//  Created by Akmal Hakim on 11/07/24.
//

import SwiftUI

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
        .presentationDetents([.fraction(0.4)])
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
