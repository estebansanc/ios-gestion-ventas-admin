//
//  ServicesView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

struct Service: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let price: Double
    let category: String
    let comments: String
    let managerID: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id_producto"
        case name = "nombre"
        case price = "precio"
        case category = "categoria"
        case comments = "comentarios"
        case managerID = "id_gerente"
    }
}

struct ServicesView: View {
    @StateObject private var viewModel = ServicesViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.products, id: \.id) { item in
                    NavigationLink {
                        ServiceDetailView(selectedService: item)
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(item.name)
                                Text(item.price.formatted(.currency(code: "ARS")))
                            }
                            .fontWeight(.bold)
                            Text(item.category)
                            Text(item.comments)
                            Text(item.managerID.formatted())
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ServiceDetailView()
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                }
            }
            .task {
                await viewModel.fetchServices()
            }
            .refreshable {
                await viewModel.fetchServices()
            }
            .navigationTitle("Productos")
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
    ServicesView()
}
