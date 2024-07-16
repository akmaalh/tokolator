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
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text("\(item.name)")
                        .font(.system(size: 20))
                        .lineLimit(1)
                        .foregroundColor(Color.primary)
                }
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .background(.cardHeaderBG)
                
                ZStack(alignment: .topLeading) {
                    VStack {
                        if let imageData = item.image,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .frame(height: 160)
                    
                    Text("\(selectedCount)")
                        .font(.system(size: 20, weight: .regular))
                        .padding(.horizontal, 4)
                        .frame(minWidth: 43, minHeight: 43, maxHeight: 43,alignment: .center)
                        .background(.cardHeaderBG)
                        .clipShape(CustomRoundedCorner(radius: 8, corners: [.bottomRight]))
                        .foregroundColor(Color.primary)
                        .lineLimit(1)
                }
            }
            .font(.system(size: 20))
            .frame(maxWidth: .infinity)
            .background(.cardBG)
        }
    }
}

struct CustomRoundedCorner: Shape {
    var radius: CGFloat = 0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
