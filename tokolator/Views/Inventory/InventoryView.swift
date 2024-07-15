import SwiftUI
import SwiftData

struct InventoryView: View {
    @Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]
    @State private var selectedItem: Item?
    @State private var isRestockViewPresented: Bool = false
    @State private var isAddItemViewPresented: Bool = false
    
    var body: some View {
        VStack {
            if items.isEmpty {
                ContentUnavailableView(label: {
                    Label("Empty Inventory", systemImage: "shippingbox")
                }, description: {
                    Text("You do not have any items in your inventory")
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
                                selectedItem = item
                            }) {
                                VStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text("\(item.name)")
                                                .font(.system(size: 20))
                                                .lineLimit(1)
                                                .foregroundColor(Color.primary)
                                        }
                                        .padding(.vertical, 4)
                                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                        .background(Color(uiColor: .systemGray))
                                        
                                        HStack {
                                            Text("\(item.stock)")
                                                .lineLimit(1)
                                                .foregroundColor(Color.primary)
                                        }
                                        .padding(.vertical, 4)
                                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                        .background(Color(uiColor: .systemGray2))
                                    }
                                    .font(.system(size: 20))
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                    
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
                                }
                                .background(Color(uiColor: .systemGray5))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    isRestockViewPresented = true
                }) {
                    Text("RESTOCK")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(items.isEmpty)
                
                Button(action: {
                    isAddItemViewPresented = true
                }) {
                    Text("ADD ITEM")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
            .fontWeight(.heavy)
            .background(.ultraThinMaterial)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .sheet(item: $selectedItem) { item in
            ItemDetailView(item: item)
        }
        .sheet(isPresented: $isRestockViewPresented) {
            RestockView()
        }
        .sheet(isPresented: $isAddItemViewPresented) {
            AddItemView()
        }
    }
}

#Preview {
    InventoryView()
}
