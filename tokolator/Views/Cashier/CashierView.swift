//
//  CashierView.swift
//  tokolator
//
//  Created by Rangga Biner on 12/07/24.
//

import SwiftUI
import SwiftData


struct CashierView: View {
    @Query(sort: \Item.timestamp, order: .forward) private var items: [Item]
    @StateObject private var viewModel: CashierViewModel
    @Environment(\.modelContext) private var modelContext
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: CashierViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(items) { item in
                    ItemRow(item: item, selectedCount: viewModel.selectedItemCount[item.id] ?? 0)
                        .onTapGesture { viewModel.addItem(item) }
                        .onLongPressGesture { viewModel.longPressedItem = item }
                }
            }
            
            Spacer()
            
            ControlButtons(
                onClear: viewModel.clearSelection,
                onDecrement: viewModel.decrementSelection,
                onCalculate: viewModel.calculateTotalPrice
            )
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Warning"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $viewModel.showSummarySheet) {
            SummarySheetView(
                selectedItems: items.filter { viewModel.selectedItemCount[$0.id] ?? 0 > 0 },
                selectedItemCount: viewModel.selectedItemCount,
                totalHarga: viewModel.calculatedTotalHarga,
                onSave: viewModel.updateStock,
                onCancel: { viewModel.showSummarySheet = false },
                onClear: viewModel.clearSelection,
                onSaveTransaction: viewModel.saveTransaction
            )
        }
        .sheet(item: $viewModel.longPressedItem) { item in
            ItemCountAdjustSheet(selectedItemCount: $viewModel.selectedItemCount, item: item, updateItemCount: viewModel.updateItemCount)
        }
    }
}
