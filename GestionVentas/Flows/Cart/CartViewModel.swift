//
//  CartViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 29/11/2024.
//

import SwiftUI

class CartViewModel: BaseViewModel {
    @Published var sell: Sell
    @Published private(set) var discounts: [Discount] = []
    @Published var selectedDiscountID: Int = -1 {
        didSet {
            sell.idDescuento = String(selectedDiscountID)
        }
    }
    
    var discountApplied: Bool {
        selectedDiscountID != -1
    }
    
    var updatedTotal: Double {
        guard
            discountApplied,
            let discount = discounts.first(where: { $0.id == selectedDiscountID}),
            let percent = Double(discount.percentage.replacingOccurrences(of: "%", with: ""))
        else { return 0 }
        
        return sell.total - (sell.total * (percent / 100))
    }
    
    override init() {
        self.sell = Sell(
            sellLines: [],
            paymentDetails: PaymentDetails.initial,
            idVendedor: "1",
            idCliente: "1",
            date: .init()
        )
        super.init()
    }
    
    @MainActor
    func delete(at offsets: IndexSet) {
        sell.sellLines.remove(atOffsets: offsets)
    }
    
    @MainActor
    func updateSellLine(for product: Product, count: Int) {
        guard count > 0 else { return }
        
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
    func fetchDiscounts() async {
        await callService {
            let result: DiscountResponse = try await HTTPManager.get(path: "/descuentos?onlyValid=true")
            withAnimation {
                self.discounts = result.data
            }
        }
    }
    
    @MainActor
    func cleanSell() {
        self.sell = Sell(
            sellLines: [],
            paymentDetails: PaymentDetails.initial,
            idVendedor: "1",
            idCliente: "1",
            date: .init()
        )
    }
}
