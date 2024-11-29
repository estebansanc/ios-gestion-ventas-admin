//
//  AnalysisViewModel.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 29/11/2024.
//

import SwiftUI

struct AnalysisRequest: Codable {
    let from: Date
    let to: Date
    
    enum CodingKeys: String, CodingKey {
        case from = "fecha_inicio"
        case to = "fecha_fin"
    }
}

struct AnalysisResponse: Codable {
    let url: String
}

class AnalysisViewModel: BaseViewModel {
    @Published var fromDate: Date = .init()
    @Published var toDate: Date = .init()
    @Published var imageUrlString: String = ""
    
    @Published var sellers: [Seller] = []
    @Published var sellerID: Int = -1 {
        didSet {
            
        }
    }
    @Published var sellerName: String = ""
    
    @MainActor
    func fetchImage() async {
        await callService {
            let body = AnalysisRequest(
                from: fromDate,
                to: toDate
            )
            
            var queryParams: String = "fecha_inicio=\(fromDate.convertDateToString())&fecha_fin=\(toDate.convertDateToString())"
            
            if sellerID != -1 {
                queryParams.append("&idVendedor=\(sellerID)&nombreVendedor=\(sellerName)")
                let response: AnalysisResponse = try await HTTPManager.post(
                    absolutePath: "https://pythonadmin.lunahri.net.ar/analizarVentasVendedor?\(queryParams)",
                    body: body
                )
                print(response.url)
                withAnimation {
                    self.imageUrlString = response.url
                }
            } else {
                let response: AnalysisResponse = try await HTTPManager.post(
                    absolutePath: "https://pythonadmin.lunahri.net.ar/analizarVentasPorVendedores?\(queryParams)",
                    body: body
                )
                print(response.url)
                withAnimation {
                    self.imageUrlString = response.url
                }
            }
        }
    }
    
    @MainActor
    func fetchSellers() async {
        await callService {
            let result: SellerResponse = try await HTTPManager.get(path: "/vendedores")
            withAnimation {
                self.sellers = result.data
            }
        }
    }
}
