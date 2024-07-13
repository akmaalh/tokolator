//
//  ItemCountAdjustSheet.swift
//  tokolator
//
//  Created by Rangga Biner on 13/07/24.
//

import SwiftUI

struct ItemCountAdjustSheet: View {
    @Binding var selectedItemCount: [UUID: Int]
    let item: Item
    let updateItemCount: (Item, Int) -> Void
    @State private var count: String
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""

    init(selectedItemCount: Binding<[UUID: Int]>, item: Item, updateItemCount: @escaping (Item, Int) -> Void) {
        self._selectedItemCount = selectedItemCount
        self.item = item
        self.updateItemCount = updateItemCount
        self._count = State(initialValue: "\(selectedItemCount.wrappedValue[item.id] ?? 0)")
    }

    var body: some View {
        VStack {
            Text(item.name)
                .font(.headline)
                .padding()
            if let imageData = item.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }
            Text("Available Stock: \(item.stock)")
                .foregroundColor(.secondary)
                .padding(.bottom)
            TextField("Count", text: $count)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("Total Price: \((Int(count) ?? 0) * item.price)")
                .font(.headline)
                .padding()
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                Button("Update") {
                    updateCount()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
            .padding()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Warning"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func updateCount() {
        if let newCount = Int(count) {
            if newCount > item.stock {
                    showAlert(message: "Jumlah melebihi stok yang tersedia. Stok \(item.name) tersedia: \(item.stock)")
            } else {
                updateItemCount(item, newCount)
                dismiss()
            }
        } else {
            showAlert(message: "Mohon masukkan angka yang valid")
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
