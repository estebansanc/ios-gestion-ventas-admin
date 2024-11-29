//
//  HistoryViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 29/11/2024.
//

import Foundation
import SwiftUI

struct Movement: Codable {
    let id: Int
    let date: String
    let sellerName: String
    let clientName: String
    let total: String
    let sellLines: [SellLine]
    let paymentDetails: PaymentDetails
    
    struct SellLine: Codable, Identifiable {
        var id: String { productName + count + productPrecio + subtotal }
        let productName: String
        let count: String
        let productPrecio: String
        let subtotal: String
    }
    
    struct PaymentDetails: Codable {
        let paymentMethod: String
        let cardDetails: CardDetails
        let cashPaymentDetails: CashPaymentDetails
    }
    
    struct CardDetails: Codable {
        let number: String?
        let name: String?
        let expirationDate: String?
    }
    
    struct CashPaymentDetails: Codable {
        let amount: String?
        let returned: String?
    }
}

struct HistoryResponse: Codable {
    let message: String
    let data: [Movement]
}

class HistorysViewModel: BaseViewModel {
    @Published private(set) var movements: [Movement] = []
    
    @MainActor
    func fetchHistorys() async {
        await callService {
            let result: HistoryResponse = try await HTTPManager.get(path: "/ventas")
            withAnimation {
                self.movements = result.data
            }
        }
    }
}
