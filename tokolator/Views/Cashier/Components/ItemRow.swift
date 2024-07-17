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
                        .padding(6)
                }
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .background(.cardHeaderBG)
                
                ZStack(alignment: .topTrailing) {
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
                        .frame(minWidth: 43, minHeight: 43, alignment: .center)
                        .background(.circleBG)
                        .clipShape(CustomRoundedCorner(radius: 43, corners: [.allCorners]))
                        .padding(7)
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
