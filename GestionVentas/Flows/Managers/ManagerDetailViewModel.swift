//
//  ManagerDetailViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import SwiftUI

class ManagerDetailViewModel: BaseViewModel {
    var selectedManager: Manager? = nil
    
    @Published var navigationTitle: String = "Agregar"
    @Published var buttonText: String = "Crear"
    
    @Published var name: String = ""
    @Published var lastname: String = ""
    @Published var email: String = ""
    @Published var dni: String = ""
    @Published var address: String = ""
    @Published var dismiss: Bool = false
    
    @MainActor
    func createManager() async {
        await callService {
            let body = Manager(
                id: 0,
                name: name,
                lastname: lastname,
                email: email,
                dni: dni,
                address: address
            )
            
            let _: CreateManagerResponse = try await HTTPManager.post(
                path: "/gerentes/add",
                body: body
            )
            
            withAnimation {
                self.dismiss = true
            }
        }
    }
    
    @MainActor
    func updateManager() async {
        guard let selectedManager else { return }
        await callService {
            let body = Manager(
                id: selectedManager.id,
                name: name,
                lastname: lastname,
                email: email,
                dni: dni,
                address: address
            )
            
            let _: CreateManagerResponse = try await HTTPManager.put(
                path: "/gerentes/\(selectedManager.id)",
                body: body
            )
            
            withAnimation {
                self.dismiss = true
            }
        }
    }
    
    @MainActor
    func set(selectedManager: Manager?) {
        self.selectedManager = selectedManager
        
        if let selectedManager {
            navigationTitle = "Editar"
            buttonText = "Guardar"
            
            name = selectedManager.name
            lastname = selectedManager.lastname
            email = selectedManager.email
            dni = selectedManager.dni
            address = selectedManager.address
        }
    }
}
