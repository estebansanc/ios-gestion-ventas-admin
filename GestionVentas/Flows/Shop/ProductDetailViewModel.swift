//
//  ProductDetailViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 29/11/2024.
//

import SwiftUI

class ProductDetailViewModel: BaseViewModel {
    @Published var count: Int = 0
    @Published var product: Product? = nil
    
    var subtotal: Double {
        guard let product else { return 0 }
        return Double(count) * product.price
    }
    
    @MainActor
    func fetchDetail(productID: Int) async {
        await callService {
            let result: Product = try await HTTPManager.get(path: "/productos/\(productID)")
            withAnimation {
                self.product = result
            }
        }
    }
}
