//
//  SellersView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

struct Seller: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let lastname: String
    let email: String
    let dni: Int
    let address: String
    let idGerente: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id_vendedor"
        case name = "nombre"
        case lastname = "apellido"
        case email = "correo"
        case dni
        case address = "direccion"
        case idGerente = "id_gerente"
    }
}

struct SellersView: View {
    @StateObject private var viewModel = SellersViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sellers, id: \.id) { seller in
                    NavigationLink {
                        SellerDetailView(selectedSeller: seller)
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(seller.name)
                                Text(seller.lastname)
                            }
                            .fontWeight(.bold)
                            Text(seller.email)
                            Text("\(seller.dni)")
                            Text(seller.address)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SellerDetailView()
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                }
            }
            .task {
                await viewModel.fetchSellers()
            }
            .refreshable {
                await viewModel.fetchSellers()
            }
            .navigationTitle("Vendedores")
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
}

#Preview {
    SellersView()
}
