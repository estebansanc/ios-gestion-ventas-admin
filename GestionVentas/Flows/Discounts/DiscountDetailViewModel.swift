//
//  DiscountDetailViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import SwiftUI

class DiscountDetailViewModel: BaseViewModel {
    var selectedDiscount: Discount? = nil
    
    @Published var navigationTitle: String = "Agregar"
    @Published var buttonText: String = "Crear"
    
    @Published var description: String = ""
    @Published var percentage: Double = 0
    @Published var expirationDate: Date = .init()
    @Published var managerID: String = ""
    @Published var dismiss: Bool = false
    
    @MainActor
    func createDiscount() async {
        await callService {
            let managerID = Int(managerID) ?? 0
            let body = Discount(
                id: 0,
                description: description,
                percentage: percentage.formatted(.percent),
                expirationDate: expirationDate,
                managerID: managerID
            )
            
            let _: CreateDiscountResponse = try await HTTPManager.post(
                path: "/descuentos/add/\(managerID)",
                body: body
            )
            
            withAnimation {
                self.dismiss = true
            }
        }
    }
    
    @MainActor
    func updateDiscount() async {
        guard let selectedDiscount else { return }
        await callService {
            let managerID = Int(managerID) ?? 0
            let body = Discount(
                id: 0,
                description: description,
                percentage: percentage.formatted(.percent),
                expirationDate: expirationDate,
                managerID: managerID
            )
            
            let _: CreateDiscountResponse = try await HTTPManager.put(
                path: "/descuentos/\(selectedDiscount.id)",
                body: body
            )
            
            withAnimation {
                self.dismiss = true
            }
        }
    }
    
    @MainActor
    func set(selectedDiscount: Discount?) {
        self.selectedDiscount = selectedDiscount
        
        if let selectedDiscount {
            navigationTitle = "Editar"
            buttonText = "Guardar"
            
            description = selectedDiscount.description
            percentage = Double(selectedDiscount.percentage) ?? 0
            expirationDate = selectedDiscount.expirationDate
            managerID = selectedDiscount.managerID.formatted()
        }
    }
}
