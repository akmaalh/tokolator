import SwiftUI
import SwiftData

struct ItemCard: View {
    var item: Item
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(item.name)")
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding(.vertical, 4)
            .background(Color.cardHeaderBG)
            
            VStack {
                if let imageData = item.image,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    
                }
            }
            .padding()
            .frame(height: 160)
            
            HStack {
                Text("Stock: \(item.stock)")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .lineLimit(1)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding(.vertical, 4)
            .background(Color.cardHeaderBG)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .foregroundColor(Color.primary)
        .background(Color.cardBG)
        .font(.system(size: 20))
        .cornerRadius(10)
    }
}
