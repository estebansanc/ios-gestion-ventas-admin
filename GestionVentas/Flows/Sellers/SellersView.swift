//
//  SellersView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

struct Seller: Identifiable, Codable {
    let id: Int
    let nombre: String
    let apellido: String
    let correo: String
    let dni: Int
    let idGerente: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_vendedor"
        case nombre
        case apellido
        case correo
        case dni
        case idGerente = "id_gerente"
    }
}

class SellersViewModel: ObservableObject {
    @Published private(set) var sellers: [Seller] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    @MainActor
    func fetchSellers() async {
        isLoading = true
        
        do {
            let result: [Seller] = try await HTTPManager.get(path: "/vendedores")
            withAnimation {
                self.sellers = result
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

struct SellersView: View {
    @StateObject private var viewModel = SellersViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.sellers, id: \.id) { seller in
                VStack(alignment: .leading) {
                    HStack {
                        Text(seller.nombre)
                        Text(seller.apellido)
                    }
                    .fontWeight(.bold)
                    Text(seller.correo)
                    Text("\(seller.dni)")
                }
            }
        }
        .toolbar {
            NavigationLink {
                Form {
                    Section("Datos del vendedor") {
                        Text("Nombre")
                        Text("Apellido")
                        Text("Correo electronico")
                        Text("DNI")
                    }
                    
                    Label("Crear", systemImage: "plus.circle")
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .navigationTitle("Agregar vendedor")
            } label: {
                Label("Agregar", systemImage: "plus.circle")
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

#Preview {
    SellersView()
}
