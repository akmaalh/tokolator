import SwiftUI
import SwiftData

struct RestockView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.name) private var items: [Item]
    @FocusState private var focusedField: Field?
    
    @State private var quantities: [Item.ID: Int] = [:]
    @State private var price: Int = 0
    
    private enum Field {
        case price, quantity
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 8.0) {
                    Text("\(item.name)")
                        .font(.title)
                    
                    HStack {
                        Text("Quantity:")
                        TextField("Quantity", value: Binding(
                            get: {
                                quantities[item.id] ?? 0
                            },
                            set: { newValue in
                                quantities[item.id] = newValue
                            }
                        ), format: .number)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .quantity)
                    }
                    
                    HStack {
                        Text("Price:")
                        TextField("Price", value: $price, format: .number)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .price)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    saveQuantities()
                }, label: {
                    Text("Save")
                })
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    focusedField = nil
                }
            }
        }
    }
    
    private func saveQuantities() {
        for item in items {
            if let quantity = quantities[item.id] {
                item.stock += quantity
            }
        }

        presentationMode.wrappedValue.dismiss()
    }
}
