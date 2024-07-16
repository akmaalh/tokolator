//
//  EditQuantitySheet.swift
//  tokolator
//
//  Created by Rangga Biner on 16/07/24.
//

import SwiftUI
import SwiftData

struct EditQuantitySheet: View {
    @Binding var selectedItemCount: [UUID: Int]
    let item: Item
    let updateItemCount: (Item, Int) -> Void
    @State private var count: String
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @FocusState private var focusedField: Field?
    @State private var newPrice: String = ""
    @State private var showSuccessAlert = false

    init(selectedItemCount: Binding<[UUID: Int]>, item: Item, updateItemCount: @escaping (Item, Int) -> Void) {
        self._selectedItemCount = selectedItemCount
        self.item = item
        self.updateItemCount = updateItemCount
        self._count = State(initialValue: "\(selectedItemCount.wrappedValue[item.id] ?? 0)")
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.name)
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.top, 27)

                    Text("Add Item")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                    HStack(spacing: 10) {
                        Text("Quantity:")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.primary)
                        
                        ZStack(alignment: .trailing) {
                            TextField("", text: $count)
                                .keyboardType(.numberPad)
                                .font(.system(size: 17))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .cornerRadius(10)
                            
                            if !count.isEmpty {
                                Button(action: {
                                    count = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 22)
                
                Spacer()

                
                HStack(spacing: 23) {
                    Button(action: { dismiss() }) {
                        Label("CANCEL", systemImage: "xmark.circle")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 20, weight: .regular))
                    }
                    .buttonStyle(CustomButtonStyle(color: .red))
                    
                    Button(action: { updateCount() }) {
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
            Alert(title: Text("Warning"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Quantity of items successfully updated.")
        }
        .presentationDetents([.fraction(0.4)])
        .presentationDragIndicator(.visible)
    }

    private func updateCount() {
        if let newCount = Int(count) {
            if newCount > item.stock {
                showAlert(message: "Quantity exceeds available stock. Available stock: \(item.stock)")
            } else {
                updateItemCount(item, newCount)
                showSuccessAlert = true
            }
        } else {
            showAlert(message: "Please enter a valid number.")
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}


struct CustomButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
