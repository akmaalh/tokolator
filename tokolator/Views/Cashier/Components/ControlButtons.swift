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
        HStack {
            Button(action: onClear) {
                Text("CLEAR")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 100, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Button(action: onDecrement) {
                Text("-")
                    .font(.system(size: 30, weight: .bold))
                    .frame(width: 100, height: 50)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Button(action: onCalculate) {
                Text("=")
                    .font(.system(size: 30, weight: .bold))
                    .frame(width: 100, height: 50)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
