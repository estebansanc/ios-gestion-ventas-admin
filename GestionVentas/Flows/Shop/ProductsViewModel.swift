//
//  ProductsViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 21/11/2024.
//

import SwiftUI

struct Product: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let price: Double
    let category: String
    let commentary: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id_producto"
        case name = "nombre"
        case price = "precio"
        case category = "categoria"
        case commentary = "comentarios"
    }
}

struct ProductsResponse: Codable {
    let message: String
    let data: [Product]
}

class ProductsViewModel: BaseViewModel {
    @Published private(set) var products: [Product] = []
    
    @MainActor
    func fetchProducts() async {
        await callService {
            let result: ProductsResponse = try await HTTPManager.get(path: "/productos")
            withAnimation {
                products = result.data
            }
        }
    }
}
