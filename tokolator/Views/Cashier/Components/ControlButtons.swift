//
//  ControlButtons.swift
//  tokolator
//
//  Created by Rangga Biner on 13/07/24.
//

import SwiftUI

struct ControlButtons: View {
    let onClear: () -> Void
    let onDecrement: () -> Void
    let onCalculate: () -> Void
    let onHapticFeedback: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                onClear()
                onHapticFeedback()
            }) {
                Text("CLEAR")
                    .frame(maxWidth: .infinity, minHeight: 24, maxHeight: 24)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.clearBGControlButton)
            
            Button(action: {
                onDecrement()
                onHapticFeedback()
            }) {
                Image(systemName: "minus")
                    .frame(maxWidth: .infinity, minHeight: 24, maxHeight: 24)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.undoBGControlButton)
            
            Button(action: {
                onCalculate()
                onHapticFeedback()
            }) {
                Image(systemName: "equal")
                    .frame(maxWidth: .infinity, minHeight: 24, maxHeight: 24)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.calculateBGControlButton)
        }
        .foregroundColor(Color.primary)
    }
}
