//
//  ClientsView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 21/11/2024.
//

import SwiftUI

struct Client: Identifiable, Codable {
    let id: Int
    let nombre: String
    let apellido: String
    let correo: String?
    let direccion: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_cliente"
        case nombre
        case apellido
        case correo
        case direccion
    }
}

class ClientsViewModel: ObservableObject {
    @Published private(set) var clients: [Client] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    @MainActor
    func fetchClients() async {
        isLoading = true
        
        do {
            let result: [Client] = try await HTTPManager.get(path: "/clientes")
            withAnimation {
                self.clients = result
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

struct ClientsView: View {
    @StateObject private var viewModel = ClientsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.clients, id: \.id) { client in
                VStack(alignment: .leading) {
                    HStack {
                        Text(client.nombre)
                        Text(client.apellido)
                    }
                    .fontWeight(.bold)
                    Text(client.correo ?? "")
                    Text(client.direccion ?? "")
                }
            }
        }
        .toolbar {
            NavigationLink {
                Form {
                    Section("Datos del cliente") {
                        Text("Nombre")
                        Text("Apellido")
                        Text("Correo electronico")
                        Text("Dirección")
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

#Preview {
    ClientsView()
}
