//
//  ProductDetailView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

class ProductDetailViewModel: BaseViewModel {
    var productID: Int
    
    @Published var count: Int = 0
    @Published var product: Product? = nil
    
    var subtotal: Double {
        guard let product else { return 0 }
        return Double(count) * product.price
    }
    
    init(productID: Int) {
        self.productID = productID
    }
    
    @MainActor
    func fetchDetail() async {
        await callService {
            let result: Product = try await HTTPManager.get(path: "/productos/\(productID)")
            withAnimation {
                self.product = result
            }
        }
    }
}

struct ProductDetailView: View {
    @EnvironmentObject private var viewModel: ProductDetailViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            if let product = viewModel.product {
                AsyncImage(
                    url: URL(string: "https://www.paredro.com/wp-content/uploads/2016/05/Prasad-Bhat-03.gif")
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .frame(maxWidth: .infinity)
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
        .onAppear {
            Task {
                await viewModel.fetchDetail()
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
    }
}

#Preview {
    ProductDetailView()
        .environmentObject(ProductDetailViewModel(productID: 1))
        .environmentObject(CartViewModel())
}
