//
//  ProductsView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

enum Route: Hashable {
    case productDetail(productID: Int)
    case cart
    case checkout(sell: Sell)
}

struct ProductsView: View {
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var viewModel = ProductsViewModel()
    @State private var showCart: Bool = false
    @State private var path = NavigationPath()
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(viewModel.products, id: \.id) { product in
                    NavigationLink(value: Route.productDetail(productID: product.id)) {
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .fontWeight(.bold)
                            Text(product.category)
                                .font(.footnote)
                            Text("Precio: \(product.price.formatted(.currency(code: "ARS")))")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: Route.cart) {
                        HStack {
                            Text("Carrito (\(cartViewModel.sell.totalCount))")
                            Image(systemName: "cart")
                        }
                        .padding()
                        .fontWeight(.bold)
                        .matchedTransitionSource(id: "cart-button", in: namespace)
                    }
                }
            }
            .navigationTitle("Comprar")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .productDetail(let productID):
                    ProductDetailView(productID: productID)
                        .environmentObject(cartViewModel)
                case .cart:
                    CartView(path: $path)
                        .environmentObject(cartViewModel)
                        .navigationTransition(.zoom(sourceID: "cart-button", in: namespace))
                case .checkout(let sell):
                    CheckoutView(path: $path, sell: sell)
                        .environmentObject(cartViewModel)
                }
            }
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("Dismiss") {
                    viewModel.error = nil
                }
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
            .task {
                await viewModel.fetchProducts()
            }
            .refreshable {
                await viewModel.fetchProducts()
            }
        }
    }
}

#Preview {
    ProductsView()
}
