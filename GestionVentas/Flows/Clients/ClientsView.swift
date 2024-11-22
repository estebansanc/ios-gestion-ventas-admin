//
//  ClientsView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 21/11/2024.
//

import SwiftUI

struct Client: Identifiable, Codable {
    let id: Int
    let name: String
    let lastname: String
    let email: String
    let address: String
    let dni: Int
    let idVendedor: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id_cliente"
        case name = "nombre"
        case lastname = "apellido"
        case email
        case address = "direccion"
        case dni
        case idVendedor
    }
}

struct ClientsResponse: Codable {
    let message: String
    let data: [Client]
}

struct CreateClientResponse: Codable {
    let message: String
}

class ClientsViewModel: ObservableObject {
    @Published private(set) var clients: [Client] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    @Published var name: String = ""
    @Published var lastname: String = ""
    @Published var email: String = ""
    @Published var address: String = ""
    @Published var dni: String = ""
    @Published var creationSuccess: Bool = false
    
    @MainActor
    func fetchClients() async {
        isLoading = true
        
        do {
            let result: ClientsResponse = try await HTTPManager.get(path: "/clientes")
            withAnimation {
                self.clients = result.data
            }
        } catch {
            debugPrint(error)
            showError(message: error.localizedDescription)
        }
        isLoading = false
    }
    
    @MainActor
    func createClient() async {
        isLoading = true
        
        do {
            let body = Client(
                id: 0,
                name: name,
                lastname: lastname,
                email: email,
                address: address,
                dni: Int(dni) ?? 0,
                idVendedor: "1"
            )
            
            let _: CreateClientResponse = try await HTTPManager.post(
                path: "/clientes/crearcliente",
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

struct ClientsView: View {
    @StateObject private var viewModel = ClientsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.clients, id: \.id) { client in
                VStack(alignment: .leading) {
                    HStack {
                        Text(client.name)
                        Text(client.lastname)
                    }
                    .fontWeight(.bold)
                    Text(client.address)
                    Text(client.email)
                    Text("\(client.dni)")
                }
            }
        }
        .toolbar {
            NavigationLink {
                AddClientView()
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
                await viewModel.fetchClients()
            }
        }
        .refreshable {
            await viewModel.fetchClients()
        }
        .navigationTitle("Clientes")
    }
}

struct AddClientView: View {
    @EnvironmentObject var viewModel: ClientsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Datos del cliente") {
                    TextField("Nombre", text: $viewModel.name)
                    TextField("Apellido", text: $viewModel.lastname)
                    TextField("Email", text: $viewModel.email)
                    TextField("Dirección", text: $viewModel.address)
                    TextField("DNI", text: $viewModel.dni)
                }
                
                Label("Crear", systemImage: "plus.circle")
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .navigationTitle("Agregar cliente")
        }
    }
}

#Preview {
    ClientsView()
}
