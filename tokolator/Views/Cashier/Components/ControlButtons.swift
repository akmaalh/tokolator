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

    var body: some View {
        HStack(spacing: 16) {
            Button(action: onClear
            ) {
                Text("CLEAR")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.clearBGControlButton)
            
            Button(action: onDecrement) {
                Text("-")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.undoBGControlButton)
            
            Button(action:
                    onCalculate) {
                Text("=")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.calculateBGControlButton)
        }
        .foregroundColor(Color.primary)
    }
}
