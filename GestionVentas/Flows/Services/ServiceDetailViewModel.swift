//
//  ServiceDetailViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import SwiftUI

class ServiceDetailViewModel: BaseViewModel {
    var selectedService: Service? = nil
    
    @Published var navigationTitle: String = "Agregar"
    @Published var buttonText: String = "Crear"
    
    @Published var name: String = ""
    @Published var price: String = ""
    @Published var category: String = ""
    @Published var comments: String = ""
    @Published var managerID: String = ""
    @Published var dismiss: Bool = false
    
    @MainActor
    func createService() async {
        await callService {
            let body = Service(
                id: 0,
                name: name,
                price: Double(price) ?? 0,
                category: category,
                comments: comments,
                managerID: Int(managerID) ?? 0
            )
            
            let _: CreateServiceResponse = try await HTTPManager.post(
                path: "/productos/crearproducto",
                body: body
            )
            
            withAnimation {
                self.dismiss = true
            }
        }
    }
    
    @MainActor
    func updateService() async {
        guard let selectedService else { return }
        await callService {
            let body = Service(
                id: selectedService.id,
                name: name,
                price: Double(price) ?? 0,
                category: category,
                comments: comments,
                managerID: Int(managerID) ?? 0
            )
            
            let _: CreateServiceResponse = try await HTTPManager.put(
                path: "/productos/\(selectedService.id)",
                body: body
            )
            
            withAnimation {
                self.dismiss = true
            }
        }
    }
    
    @MainActor
    func set(selectedService: Service?) {
        self.selectedService = selectedService
        
        if let selectedService {
            navigationTitle = "Editar"
            buttonText = "Guardar"
            
            name = selectedService.name
            price = selectedService.price.formatted(.currency(code: "ARS"))
            category = selectedService.category
            comments = selectedService.comments
            managerID = selectedService.managerID.formatted()
        }
    }
}
