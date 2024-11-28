//
//  SellersViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import Foundation
import SwiftUI

struct SellerResponse: Codable {
    let message: String
    let data: [Seller]
}

struct CreateSellerResponse: Codable {
    let message: String
}

class SellersViewModel: BaseViewModel {
    @Published private(set) var sellers: [Seller] = []
    @Published private(set) var selectedSeller: Seller? = nil
    
    @Published var name: String = ""
    @Published var lastname: String = ""
    @Published var email: String = ""
    @Published var dni: String = ""
    @Published var address: String = ""
    @Published var creationSuccess: Bool = false
    
    @MainActor
    func fetchSellers() async {
        await callService {
            let result: SellerResponse = try await HTTPManager.get(path: "/vendedores")
            withAnimation {
                self.sellers = result.data
            }
        }
    }
    
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
                self.creationSuccess = true
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
            
            let _: CreateSellerResponse = try await HTTPManager.post(
                path: "/vendedores/\(selectedSeller.id)",
                body: body
            )
            
            withAnimation {
                self.creationSuccess = true
            }
        }
    }
    
    @MainActor
    func set(selectedSeller: Seller?) {
        self.selectedSeller = selectedSeller
        
        if let selectedSeller {
            name = selectedSeller.name
            lastname = selectedSeller.lastname
            email = selectedSeller.email
            dni = String(selectedSeller.dni)
            address = selectedSeller.address
        }
    }
}
