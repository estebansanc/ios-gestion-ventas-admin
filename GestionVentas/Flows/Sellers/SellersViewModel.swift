//
//  SellersViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import Foundation
import SwiftUI

struct SellerResponse: Codable {
    let message: String
    let data: [Seller]
}

struct CreateSellerResponse: Codable {
    let message: String
}

class SellersViewModel: BaseViewModel {
    @Published private(set) var sellers: [Seller] = []
    
    @MainActor
    func fetchSellers() async {
        await callService {
            let result: SellerResponse = try await HTTPManager.get(path: "/vendedores")
            withAnimation {
                self.sellers = result.data
            }
        }
    }
}
