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

class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    @Published var count: Int = 0
    @Published var selectedProduct: Product? = nil
    var selectedProductID: Int? = nil
    
    var subtotal: Double {
        guard let selectedProduct else { return 0 }
        return Double(count) * selectedProduct.price
    }
    
    @MainActor
    func fetchProducts() async {
        isLoading = true
        
        do {
            let result: ProductsResponse = try await HTTPManager.get(path: "/productos")
            withAnimation {
                self.products = result.data
            }
        } catch {
            showError(error, message: error.localizedDescription)
        }
        isLoading = false
    }
    
    @MainActor
    func fetchDetail() async {
        guard let productID = selectedProductID else {
            showError(message: "Ningun producto seleccionado")
            return
        }
        
        isLoading = true
        
        do {
            let result: Product = try await HTTPManager.get(path: "/productos/\(productID)")
            withAnimation {
                self.selectedProduct = result
            }
        } catch {
            showError(error, message: error.localizedDescription)
        }
        
        isLoading = false
    }
    
    @MainActor
    private func showError(_ error: Error? = nil, message: String) {
        if let error {
            debugPrint(error)
        }
        self.errorMessage = message
    }
}
