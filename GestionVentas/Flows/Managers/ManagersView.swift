//
//  ManagersView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

struct Manager: Identifiable, Codable {
    let id: Int
    let nombre: String
    let apellido: String
    let email: String
    let direccion: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id_gerente"
        case nombre
        case apellido
        case email
        case direccion
    }
}

class ManagersViewModel: ObservableObject {
    @Published private(set) var managers: [Manager] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    @MainActor
    func fetchManagers() async {
        isLoading = true
        
        do {
            let result: [Manager] = try await HTTPManager.get(path: "/gerentes")
            withAnimation {
                self.managers = result
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

struct ManagersView: View {
    @StateObject private var viewModel = ManagersViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.managers, id: \.id) { manager in
                VStack(alignment: .leading) {
                    HStack {
                        Text(manager.nombre)
                        Text(manager.apellido)
                    }
                    .fontWeight(.bold)
                    Text(manager.email)
                    Text(manager.direccion)
                }
            }
        }
        .toolbar {
            NavigationLink {
                Form {
                    Section("Datos del gerente") {
                        Text("Nombre")
                        Text("Apellido")
                        Text("Correo electronico")
                        Text("Direccion")
                    }
                    
                    Label("Crear", systemImage: "plus.circle")
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .navigationTitle("Agregar gerente")
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
                await viewModel.fetchManagers()
            }
        }
        .refreshable {
            await viewModel.fetchManagers()
        }
        .navigationTitle("Gerentes")
    }
}

#Preview {
    ManagersView()
}
