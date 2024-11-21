//
//  ProductDetailView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

class ProductsDetailViewModel: ObservableObject {
    let productID: Int
    
    @Published private(set) var product: Product? = nil
    @Published private(set) var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @State var count: Int = 0
    
    var subtotal: Double {
        guard let product else { return 0 }
        return Double(count) * (product.precio ?? 0)
    }
    
    init(productID: Int) {
        self.productID = productID
    }
    
    @MainActor
    func fetchDetail() async {
        isLoading = true
        guard let url = URL(string: "\(BASE_URL)/productos/\(productID)") else {
            showError(message: "Invalid URL")
            return
        }
        
        do {
            let (responseData, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(Product.self, from: responseData)
            withAnimation {
                self.product = result
            }
        } catch {
            showError(message: error.localizedDescription)
        }
        
        isLoading = false
    }
    
    @MainActor
    private func showError(message: String) {
        print("Error: \(message)")
        self.errorMessage = message
    }
}

struct ProductDetailView: View {
    @EnvironmentObject private var viewModel: ProductsDetailViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            if let product = viewModel.product {
                Label("", systemImage: "photo.on.rectangle.angled")
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
                Text(product.nombre)
                    .font(.title)
                    .fontWeight(.bold)
                Text(product.categoria)
                    .font(.subheadline)
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Precio \(product.precio?.formatted(.currency(code: "ARS")) ?? "--")")
                    Divider()
                    Stepper("Cantidad x\(viewModel.count)", value: $viewModel.count.animation(), in: 0...1000)
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
//            guard let product = viewModel.product else { return }
//            viewModel.count = cartViewModel.getCount(for: product)
        }
    }
}

#Preview {
    ProductDetailView()
        .environmentObject(ProductsDetailViewModel(productID: 1))
}
