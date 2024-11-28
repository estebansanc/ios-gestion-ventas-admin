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
    @State private var addTapped: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sellers, id: \.id) { seller in
                    NavigationLink(value: seller) {
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
            .navigationDestination(for: Seller.self) { seller in
                SellerDetailView(selectedSeller: seller)
                    .environmentObject(viewModel)
            }
            .fullScreenCover(isPresented: $addTapped) {
                SellerDetailView()
                    .environmentObject(viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: "plus.circle.fill") {
                        viewModel.set(selectedSeller: nil)
                        addTapped = true
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

struct SellerDetailView: View {
    @EnvironmentObject var viewModel: SellersViewModel
    @Environment(\.dismiss) var dismiss
    @State var selectedSeller: Seller? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Datos del vendedor") {
                    TextField("Nombre", text: $viewModel.name)
                    TextField("Apellido", text: $viewModel.lastname)
                    TextField("Email", text: $viewModel.email)
                    TextField("DNI", text: $viewModel.dni)
                    TextField("Dirección", text: $viewModel.address)
                }
                
                Button {
                    Task {
                        if selectedSeller != nil {
                            await viewModel.updateSeller()
                        } else {
                            await viewModel.createSeller()
                        }
                    }
                } label: {
                    Label("Crear", systemImage: "plus.circle")
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar", systemImage: "x.mark.circle") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("\(viewModel.selectedSeller == nil ? "Nuevo" : "Editar") vendedor")
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("Dismiss") {
                    viewModel.error = nil
                }
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
            .onChange(of: viewModel.creationSuccess) { oldValue, newValue in
                if newValue {
                    dismiss()
                }
            }
            .onAppear {
                viewModel.set(selectedSeller: selectedSeller)
            }
        }
    }
}

#Preview {
    SellersView()
}
