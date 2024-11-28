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
                    NavigationLink {
                        ProductDetailView()
                            .environmentObject(ProductDetailViewModel(productID: product.id))
                            .environmentObject(cartViewModel)
                    } label: {
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
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("Dismiss") {
                    viewModel.error = nil
                }
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
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
