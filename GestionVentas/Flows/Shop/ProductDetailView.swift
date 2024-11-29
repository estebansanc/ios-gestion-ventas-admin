//
//  ProductDetailView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject private var cartViewModel: CartViewModel
    @StateObject private var viewModel = ProductDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    @State var productID: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            if let product = viewModel.product {
                Image("service-image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding()
                
                Text(product.name)
                    .font(.title)
                    .fontWeight(.bold)
                Text(product.category)
                    .font(.subheadline)
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Precio \(product.price.formatted(.currency(code: "ARS")))")
                    Divider()
                    Stepper("Cantidad x\(viewModel.count)", value: $viewModel.count.animation())
                        .contentTransition(.numericText())
                    Divider()
                    HStack {
                        Text("Subtotal: \(viewModel.subtotal.formatted(.currency(code: "ARS")))")
                            .contentTransition(.numericText())
                        Spacer()
                        Button("Confirmar") {
                            cartViewModel.updateSellLine(
                                for: product,
                                count: viewModel.count
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
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            ProgressView()
                .opacity(viewModel.isLoading ? 1 : 0)
        )
        .task {
            await viewModel.fetchDetail(productID: productID)
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
    }
}

#Preview {
    ProductDetailView(productID: 1)
        .environmentObject(CartViewModel())
}
