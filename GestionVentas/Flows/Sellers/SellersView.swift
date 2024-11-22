//
//  SellersView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

struct Seller: Identifiable, Codable {
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

struct SellerResponse: Codable {
    let message: String
    let data: [Seller]
}

struct CreateSellerResponse: Codable {
    let message: String
}

class SellersViewModel: ObservableObject {
    @Published private(set) var sellers: [Seller] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    @Published var name: String = ""
    @Published var lastname: String = ""
    @Published var email: String = ""
    @Published var dni: String = ""
    @Published var address: String = ""
    @Published var creationSuccess: Bool = false
    
    @MainActor
    func fetchSellers() async {
        isLoading = true
        
        do {
            let result: SellerResponse = try await HTTPManager.get(path: "/vendedores")
            withAnimation {
                self.sellers = result.data
            }
        } catch {
            debugPrint(error)
            showError(message: error.localizedDescription)
        }
        isLoading = false
    }
    
    @MainActor
    func createSeller() async {
        isLoading = true
        
        do {
            let body = Seller(
                id: 0,
                name: name,
                lastname: lastname,
                email: email,
                dni: Int(dni) ?? 0,
                address: address,
                idGerente: 1
            )
            
            let _: CreateSellerResponse = try await HTTPManager.post(
                path: "/vendedores/crearvendedor",
                body: body
            )
            
            withAnimation {
                self.creationSuccess = true
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

struct SellersView: View {
    @StateObject private var viewModel = SellersViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    AddSellersView()
                        .environmentObject(viewModel)
                } label: {
                    Label("Agregar", systemImage: "plus.circle")
                }
                ForEach(viewModel.sellers, id: \.id) { seller in
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
            .alert(
                viewModel.errorMessage,
                isPresented: .init(
                    get: { !viewModel.errorMessage.isEmpty },
                    set: { _ in viewModel.errorMessage = "" }
                ),
                actions: {}
            )
            .onAppear {
                Task {
                    await viewModel.fetchSellers()
                }
            }
            .refreshable {
                await viewModel.fetchSellers()
            }
            .navigationTitle("Vendedores")
        }
    }
}

struct AddSellersView: View {
    @EnvironmentObject var viewModel: SellersViewModel
    @Environment(\.dismiss) var dismiss
    
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
                    Task { await viewModel.createSeller() }
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
            .onChange(of: viewModel.creationSuccess) { oldValue, newValue in
                if newValue {
                    dismiss()
                }
            }
            .navigationTitle("Agregar vendedor")
        }
    }
}

#Preview {
    SellersView()
}
