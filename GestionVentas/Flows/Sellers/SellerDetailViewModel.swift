//
//  SellerDetailViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import SwiftUI

class SellerDetailViewModel: BaseViewModel {
    var selectedSeller: Seller? = nil
    
    @Published var navigationTitle: String = "Agregar"
    @Published var buttonText: String = "Crear"
    
    @Published var name: String = ""
    @Published var lastname: String = ""
    @Published var email: String = ""
    @Published var dni: String = ""
    @Published var address: String = ""
    @Published var dismiss: Bool = false
    
    @MainActor
    func createSeller() async {
        await callService {
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
                self.dismiss = true
            }
        }
    }
    
    @MainActor
    func updateSeller() async {
        guard let selectedSeller else { return }
        await callService {
            let body = Seller(
                id: selectedSeller.id,
                name: name,
                lastname: lastname,
                email: email,
                dni: Int(dni) ?? 0,
                address: address,
                idGerente: 1
            )
            
            let _: CreateSellerResponse = try await HTTPManager.put(
                path: "/vendedores/\(selectedSeller.id)",
                body: body
            )
            
            withAnimation {
                self.dismiss = true
            }
        }
    }
    
    @MainActor
    func set(selectedSeller: Seller?) {
        self.selectedSeller = selectedSeller
        
        if let selectedSeller {
            navigationTitle = "Editar"
            buttonText = "Guardar"
            
            name = selectedSeller.name
            lastname = selectedSeller.lastname
            email = selectedSeller.email
            dni = String(selectedSeller.dni)
            address = selectedSeller.address
        }
    }
}
