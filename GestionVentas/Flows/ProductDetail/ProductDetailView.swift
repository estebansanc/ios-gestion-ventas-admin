//
//  ProductDetailView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct ProductDetailView: View {
    @State var product: Product
    @EnvironmentObject private var cartViewModel: CartViewModel
    @State private var count: Int = 0
    @Environment(\.dismiss) var dismiss
    
    var subtotal: Double {
        Double(count) * product.price
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Label("", systemImage: "photo.on.rectangle.angled")
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            
            Text(product.title)
                .font(.title)
                .fontWeight(.bold)
            Text(product.subtitle)
                .font(.subheadline)
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Precio $\(product.price.formatted())")
                Divider()
                Stepper("Cantidad x\(count)", value: $count.animation(), in: 0...1000)
                    .contentTransition(.numericText())
                Divider()
                HStack {
                    Text("Subtotal: $\(subtotal.formatted())")
                        .contentTransition(.numericText())
                    Spacer()
                    Button("Confirmar") {
                        cartViewModel.updateSellLine(
                            for: product,
                            count: count
                        )
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            count = cartViewModel.getCount(for: product)
        }
    }
}

#Preview {
    ProductDetailView(product: mockProducts.first!)
}
