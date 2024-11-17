//
//  ProductsView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct Product: Identifiable, Hashable {
    var id: Int
    var title: String
    var subtitle: String
    var price: Double
}

struct ProductsView: View {
    @State var total: Double = 40
    @State var products: [Product] = mockProducts
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(products, id: \.id) { product in
                    NavigationLink(value: product) {
                        VStack {
                            Group {
                                Text(product.title)
                                    .fontWeight(.bold)
                                Text(product.subtitle)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Spacer()
                                Text("$ \(product.price.formatted())")
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Product.self) { product in
                Text(product.title)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        Text("Carrito")
                    } label: {
                        HStack {
                            Text("$ \(total.formatted())")
                            Image(systemName: "cart")
                        }
                        .padding()
                        .fontWeight(.bold)
                    }

                }
            }
            .navigationTitle("Comprar")
        }
    }
}

#Preview {
    ProductsView()
}
