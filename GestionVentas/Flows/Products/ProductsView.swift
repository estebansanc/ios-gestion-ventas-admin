//
//  ProductsView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var viewModel = ProductsViewModel()
    @State private var showCart: Bool = false
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.products, id: \.id) { product in
                    NavigationLink(value: product) {
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
            .navigationDestination(for: Product.self) { product in
                viewModel.selectedProductID = product.id
                return ProductDetailView()
                    .environmentObject(cartViewModel)
                    .environmentObject(viewModel)
            }
            .fullScreenCover(isPresented: $showCart) {
                CartView()
                    .environmentObject(cartViewModel)
                    .navigationTransition(.zoom(sourceID: "cart-button", in: namespace))
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCart = true
                    } label: {
                        HStack {
                            Text("Carrito")
                            Image(systemName: "cart")
                        }
                        .padding()
                        .fontWeight(.bold)
                        .matchedTransitionSource(id: "cart-button", in: namespace)
                    }
                    .buttonStyle(.plain)
                }
            }
            .alert(
                viewModel.errorMessage,
                isPresented: .init(
                    get: { !viewModel.errorMessage.isEmpty },
                    set: { _ in viewModel.errorMessage = "" }
                )
            ) { }
            .onAppear {
                Task {
                    await viewModel.fetchProducts()
                }
            }
            .refreshable {
                await viewModel.fetchProducts()
            }
            .navigationTitle("Comprar")
        }
    }
}

#Preview {
    ProductsView()
}
