//
//  CheckoutViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 29/11/2024.
//

import SwiftUI

struct CreateSellResponse: Codable {
    let message: String
}

class CheckoutViewModel: BaseViewModel {
    @Published private(set) var sell: Sell? = nil
    @Published private(set) var clients: [Client] = []
    @Published private(set) var discounts: [Discount] = []
    @Published private(set) var selectedDiscount: Discount? = nil
    
    var discountApplied: Bool {
        return selectedDiscount != nil
    }
    
    var total: Double {
        guard let sell else { return 0 }
        return sell.total
    }
    
    var updatedTotal: Double {
        guard
            discountApplied,
            let sell = sell,
            let discountID = Int(sell.idDescuento ?? ""),
            let discount = discounts.first(where: { $0.id == discountID}),
            let percent = Double(discount.percentage.replacingOccurrences(of: "%", with: ""))
        else { return 0 }
        
        return sell.total - (sell.total * (percent / 100))
    }
    
    @Published var selectedClientID: Int = -1 {
        didSet {
            selectedClient = clients.first(where: { $0.id == selectedClientID })
        }
    }
    @Published var selectedClient: Client? = nil
    
    @Published var paymentMethod: PaymentMethods = .cash
    @Published var cardNumber: String = ""
    @Published var cardName: String = ""
    @Published var cardCvv: String = ""
    @Published var cardDate: String = ""
    @Published var amount: Double = 0
    @Published var successSell: Bool = false
    
    var isInputValid: Bool {
        guard selectedClientID != -1 else { return false }
        switch paymentMethod {
        case .cash:
            if discountApplied {
                return amount >= updatedTotal
            } else {
                guard let total = sell?.total else { return false}
                return amount >= total
            }
        case .card:
            guard
                !cardName.isEmpty,
                !cardNumber.isEmpty,
                !cardCvv.isEmpty,
                !cardDate.isEmpty
            else { return false }
            return true
        }
    }
    
    var returnAmount: Double {
        guard let sell else { return 0 }
        if let updatedTotal = sell.totalWithDiscount {
            return max(amount - updatedTotal, 0)
        } else {
            return max(amount - sell.total, 0)
        }
    }
    
    @MainActor
    func load(sell: Sell) {
        self.sell = sell
    }
    
    @MainActor
    func pay() async {
        guard let sell else { return }
        await callService {
            let body: SellRequest.Request = SellRequestMapper.map(sell)
            let _: CreateSellResponse = try await HTTPManager.post(path: "/ventas/create", body: body)
            withAnimation {
                self.sell = nil
                self.successSell = true
            }
        }
    }
    
    @MainActor
    func fetchClients() async {
        await callService {
            let result: ClientResponse = try await HTTPManager.get(path: "/clientes")
            withAnimation {
                self.clients = result.data
            }
        }
    }
    
    @MainActor
    func fetchDiscounts() async {
        await callService {
            let result: DiscountResponse = try await HTTPManager.get(path: "/descuentos?onlyValid=true")
            withAnimation {
                self.discounts = result.data
                calculateSelectedDiscount()
            }
        }
    }
    
    @MainActor
    private func calculateSelectedDiscount() {
        guard
            let sell,
            let discountID = Int(sell.idDescuento ?? "")
        else { return }
        self.selectedDiscount = discounts.first(where: { $0.id == discountID })
        self.sell?.totalWithDiscount = updatedTotal
    }
}
