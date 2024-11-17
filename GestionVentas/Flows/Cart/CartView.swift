//
//  CartView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct SellLine: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var count: Int
    let product: Product
    
    var subtotal: Double {
        Double(count) * product.price
    }
}

struct Sell: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var sellLines: [SellLine]
    var paymentDetails: PaymentDetails?
    var sellerName: String
    var clientName: String
    var date: Date
    
    var total: Double {
        sellLines.reduce(0, { $0 + $1.subtotal })
    }
    
    var totalCount: Int {
        sellLines.reduce(0, { $0 + $1.count })
    }
    
    static func == (lhs: Sell, rhs: Sell) -> Bool {
        return lhs.id == rhs.id
    }
}

class CartViewModel: ObservableObject {
    @Published var sell: Sell
    
    init() {
        self.sell = Sell(
            sellLines: mockSellLines,
            paymentDetails: nil,
            sellerName: "Jhon",
            clientName: "Salchichon",
            date: .init()
        )
    }
    
    @MainActor
    func delete(at offsets: IndexSet) {
        sell.sellLines.remove(atOffsets: offsets)
    }
    
    @MainActor
    func updateSellLine(for product: Product, count: Int) {
        if let index = sell.sellLines.firstIndex(where: { $0.product.id == product.id }) {
            var line = sell.sellLines.remove(at: index)
            line.count = count
            sell.sellLines.append(line)
        } else {
            let newLine = SellLine(
                count: count,
                product: product
            )
            sell.sellLines.append(newLine)
        }
    }
    
    @MainActor
    func getCount(for product: Product) -> Int {
        return sell
            .sellLines
            .first(where: { $0.product.id == product.id })?
            .count ?? 0
    }
    
    @MainActor
    func updateCardPayment(
        number: String,
        name: String,
        securityCode: String,
        expirationDate: String
    ) {
        let cardDetails = CardDetails(
            number: number,
            name: name,
            securityCode: securityCode,
            expirationDate: expirationDate
        )
        let paymentDetails = PaymentDetails(
            paymentMethod: .card,
            cardDetails: cardDetails,
            cashPaymentDetails: nil,
            date: .init()
        )
        sell.paymentDetails = paymentDetails
    }
    
    @MainActor
    func updateCashPayment(amount: String, returnAmount: Double) {
        let cashPaymentDetails = CashPaymentDetails(
            amount: Double(amount) ?? 0,
            returned: returnAmount
        )
        let paymentDetails = PaymentDetails(
            paymentMethod: .cash,
            cardDetails: nil,
            cashPaymentDetails: cashPaymentDetails,
            date: .init()
        )
        sell.paymentDetails = paymentDetails
    }
}

struct CartView: View {
    @EnvironmentObject private var viewModel: CartViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sell.sellLines, id: \.id) { line in
                    sellLineView(for: line)
                }
                .onDelete { index in
                    withAnimation {
                        viewModel.delete(at: index)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                totalView
            }
            .toolbar {
                Button("Volver", systemImage: "chevron.down.circle") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                .labelStyle(.titleAndIcon)
            }
            .navigationTitle("Carrito")
        }
    }
    
    var totalView: some View {
        HStack {
            Group {
                Text("Total: $\(viewModel.sell.total.formatted())")
                    .contentTransition(.numericText())
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
                Spacer()
                NavigationLink {
                    CheckoutView()
                        .environmentObject(viewModel)
                } label: {
                    Label("Pagar", systemImage: "chevron.right.circle")
                        .labelStyle(.titleAndIcon)
                        .font(.title3)
                }
            }
            .fontWeight(.bold)
        }
        .padding()
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .accentColor.opacity(0.3), radius: 15, y: 10)
        .padding()
    }
    
    @ViewBuilder
    func sellLineView(for line: SellLine) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(line.product.title)")
                }
                Text("$ \(line.product.price.formatted()) / Unidad")
                    .font(.footnote)
                HStack(alignment: .bottom) {
                    Text("Cantidad:")
                        .font(.footnote)
                    Text("x\(line.count)")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("Subtotal:")
                        .font(.footnote)
                    Text("$\(line.subtotal.formatted())")
                        .fontWeight(.bold)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CartView()
        .environmentObject(CartViewModel())
}
