//
//  DiscountsViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import Foundation
import SwiftUI

struct DiscountResponse: Codable {
    let message: String
    let data: [Discount]
}

struct CreateDiscountResponse: Codable {
    let message: String
}

class DiscountsViewModel: BaseViewModel {
    @Published private(set) var discounts: [Discount] = []
    @Published var onlyValid: Bool = false
    
    @MainActor
    func fetchDiscounts() async {
        await callService {
            let result: DiscountResponse = try await HTTPManager.get(path: "/descuentos?onlyValid=\(onlyValid)")
            withAnimation {
                self.discounts = result.data
            }
        }
    }
}
