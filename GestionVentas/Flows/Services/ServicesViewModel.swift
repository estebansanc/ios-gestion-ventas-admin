//
//  ServicesViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import Foundation
import SwiftUI

struct ServiceResponse: Codable {
    let message: String
    let data: [Service]
}

struct CreateServiceResponse: Codable {
    let message: String
}

class ServicesViewModel: BaseViewModel {
    @Published private(set) var products: [Service] = []
    
    @MainActor
    func fetchServices() async {
        await callService {
            let result: ServiceResponse = try await HTTPManager.get(path: "/productos")
            withAnimation {
                self.products = result.data
            }
        }
    }
}
