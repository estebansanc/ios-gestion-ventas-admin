//
//  ManagersView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

struct Manager: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let lastname: String
    let email: String
    let dni: String
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id_gerente"
        case name = "nombre"
        case lastname = "apellido"
        case email
        case dni
        case address = "direccion"
    }
}

struct ManagersView: View {
    @StateObject private var viewModel = ManagersViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.managers, id: \.id) { seller in
                    NavigationLink {
                        ManagerDetailView(selectedManager: seller)
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
                        ManagerDetailView()
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                }
            }
            .task {
                await viewModel.fetchManagers()
            }
            .refreshable {
                await viewModel.fetchManagers()
            }
            .navigationTitle("Manageres")
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
    ManagersView()
}
