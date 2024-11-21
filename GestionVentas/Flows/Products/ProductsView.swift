//
//  ProductsView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct Product: Identifiable, Hashable, Codable {
    let id: Int
    let nombre: String
    let precio: Double?
    let stock: Int
    let categoria: String
    let imagen: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_producto"
        case nombre
        case precio
        case stock
        case categoria
        case imagen
    }
}

class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    @MainActor
    func fetchProducts() async {
        isLoading = true
        
        do {
            let result: [Product] = try await HTTPManager.get(path: "/productos")
            withAnimation {
                self.products = result
            }
        } catch {
            debugPrint(error)
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
                            Text(product.nombre)
                                .fontWeight(.bold)
                            Text(product.categoria)
                                .font(.footnote)
                            Text("Precio: \(product.precio?.formatted(.currency(code: "ARS")) ?? "")")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .navigationDestination(for: Product.self) { product in
                ProductDetailView()
                    .environmentObject(cartViewModel)
                    .environmentObject(ProductsDetailViewModel(productID: product.id))
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
