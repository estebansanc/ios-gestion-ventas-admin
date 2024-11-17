//
//  CartView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct ProductLine: Identifiable {
    let id: Int
    let count: Int
    let product: Product
    
    var subtotal: Double {
        Double(count) * product.price
    }
}

class CartViewModel: ObservableObject {
    @Published var productLines: [ProductLine] = []
}

struct CartView: View {
    @EnvironmentObject private var viewModel: CartViewModel
    
    var body: some View {
        List(viewModel.productLines) { productLine in
            VStack {
                
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    CartView()
        .environmentObject(CartViewModel())
}
