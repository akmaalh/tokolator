//
//  ItemRow.swift
//  tokolator
//
//  Created by Rangga Biner on 13/07/24.
//


import SwiftUI

struct ItemRow: View {
    let item: Item
    let selectedCount: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .foregroundColor(.primary)
            if let imageData = item.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 300)
            }
            Text("Stock: \(item.stock)")
                .foregroundColor(.secondary)
            Text("Count: \(selectedCount)")
                .foregroundColor(.secondary)
            Text("Total Price: \(selectedCount * item.price)")
                .foregroundColor(.secondary)
        }
    }
}
