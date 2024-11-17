//
//  ProductsView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct Product: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var title: String
    var subtitle: String
    var price: Double
}

struct ProductsView: View {
    @State var products: [Product] = mockProducts
    @State var cartViewModel = CartViewModel()
    @State var showCart: Bool = false
    @Namespace var namespace
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(products, id: \.id) { product in
                    NavigationLink(value: product) {
                        VStack(alignment: .leading) {
                            Text(product.title)
                                .fontWeight(.bold)
                            Text(product.subtitle)
                                .font(.footnote)
                            Text("Precio: $ \(product.price.formatted())")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
                    .environmentObject(cartViewModel)
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
            .navigationTitle("Comprar")
        }
    }
}

#Preview {
    ProductsView()
}
