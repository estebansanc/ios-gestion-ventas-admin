//
//  ClientsView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

struct Client: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let lastname: String
    let email: String
    let dni: Int
    let sellerID: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id_cliente"
        case name = "nombre"
        case lastname = "apellido"
        case email
        case dni
        case sellerID = "id_vendedor"
    }
}

struct ClientsView: View {
    @StateObject private var viewModel = ClientsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.clients, id: \.id) { seller in
                    NavigationLink {
                        ClientDetailView(selectedClient: seller)
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(seller.name)
                                Text(seller.lastname)
                            }
                            .fontWeight(.bold)
                            Text(seller.email)
                            Text("\(seller.dni)")
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ClientDetailView()
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                }
            }
            .task {
                await viewModel.fetchClients()
            }
            .refreshable {
                await viewModel.fetchClients()
            }
            .navigationTitle("Clientes")
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
    ClientsView()
}
