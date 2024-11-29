//
//  ManagersViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import Foundation
import SwiftUI

//struct ManagerResponse: Codable { }

struct CreateManagerResponse: Codable {
    let message: String
}

class ManagersViewModel: BaseViewModel {
    @Published private(set) var managers: [Manager] = []
    
    @MainActor
    func fetchManagers() async {
        await callService {
            let result: [Manager] = try await HTTPManager.get(path: "/gerentes")
            withAnimation {
                self.managers = result
            }
        }
    }
}
