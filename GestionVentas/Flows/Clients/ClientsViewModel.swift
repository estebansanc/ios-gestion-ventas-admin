//
//  ClientsViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import Foundation
import SwiftUI

struct ClientResponse: Codable {
    let message: String
    let data: [Client]
}

struct CreateClientResponse: Codable {
    let message: String
}

class ClientsViewModel: BaseViewModel {
    @Published private(set) var clients: [Client] = []
    
    @MainActor
    func fetchClients() async {
        await callService {
            let result: ClientResponse = try await HTTPManager.get(path: "/clientes")
            withAnimation {
                self.clients = result.data
            }
        }
    }
}
