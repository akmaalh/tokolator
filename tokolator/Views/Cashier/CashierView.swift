//
//  CashierView.swift
//  tokolator
//
//  Created by Rangga Biner on 12/07/24.
//


import SwiftUI
import SwiftData

struct CashierView: View {
    @Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]
    @StateObject private var viewModel: CashierViewModel
    @Environment(\.modelContext) private var modelContext
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: CashierViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0  ) {
                    if items.isEmpty {
                        ContentUnavailableView(label: {
                            Label("Calculator", systemImage: "plus.forwardslash.minus")
                        }, description: {
                            Text("You do not have any items to calculate")
                        }, actions: {})
                    } else {
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(items) { item in
                                    Button(action: {
                                        viewModel.addItem(item)
                                        viewModel.generateHapticFeedback()
                                    }) {
                                        ItemRow(item: item, selectedCount: viewModel.selectedItemCount[item.id] ?? 0)
                                    }
                                    .contextMenu {
                                        Button(action: {
                                            viewModel.longPressedItem = item
                                        }) {
                                            Label("Edit Quantity", systemImage: "square.and.pencil")
                                        }                      
                                    }
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }
                    
                        ControlButtons(
                            onClear: viewModel.clearSelection,
                            onDecrement: viewModel.decrementSelection,
                            onCalculate: viewModel.calculateTotalPrice,
                            onHapticFeedback: viewModel.generateHapticFeedback
                        )
                        .padding()
                        .fontWeight(.heavy)
                        .background(Color.tabBarBG)
                        .frame(maxWidth: .infinity)
                    
                }
            
            .navigationTitle("Calculator")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Warning"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $viewModel.showSummarySheet) {
                SummarySheet(
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
                EditQuantitySheet(selectedItemCount: $viewModel.selectedItemCount, item: item, updateItemCount: viewModel.updateItemCount)
            }
        }
    }
}
