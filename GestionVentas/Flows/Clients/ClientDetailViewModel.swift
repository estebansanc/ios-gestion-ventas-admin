//
//  ClientDetailViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import SwiftUI

class ClientDetailViewModel: BaseViewModel {
    var selectedClient: Client? = nil
    
    @Published var navigationTitle: String = "Agregar"
    @Published var buttonText: String = "Crear"
    
    @Published var name: String = ""
    @Published var lastname: String = ""
    @Published var email: String = ""
    @Published var dni: String = ""
    @Published var dismiss: Bool = false
    
    @MainActor
    func createClient() async {
        await callService {
            let body = Client(
                id: 0,
                name: name,
                lastname: lastname,
                email: email,
                dni: Int(dni) ?? 0,
                sellerID: 1
            )
            
            let _: CreateClientResponse = try await HTTPManager.post(
                path: "/clientes/crearcliente",
                body: body
            )
            
            withAnimation {
                self.dismiss = true
            }
        }
    }
    
    @MainActor
    func updateClient() async {
        guard let selectedClient else { return }
        await callService {
            let body = Client(
                id: selectedClient.id,
                name: name,
                lastname: lastname,
                email: email,
                dni: Int(dni) ?? 0,
                sellerID: 1
            )
            
            let _: CreateClientResponse = try await HTTPManager.put(
                path: "/clientes/\(selectedClient.id)",
                body: body
            )
            
            withAnimation {
                self.dismiss = true
            }
        }
    }
    
    @MainActor
    func set(selectedClient: Client?) {
        self.selectedClient = selectedClient
        
        if let selectedClient {
            navigationTitle = "Editar"
            buttonText = "Guardar"
            
            name = selectedClient.name
            lastname = selectedClient.lastname
            email = selectedClient.email
            dni = String(selectedClient.dni)
        }
    }
}
