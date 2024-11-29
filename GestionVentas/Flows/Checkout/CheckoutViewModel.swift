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
            guard let total = sell?.total else { return false}
            return amount >= total
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
        return max(amount - sell.total, 0)
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
}
