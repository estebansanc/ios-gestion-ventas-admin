//
//  Shared.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 21/11/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView("Cargando")
    }
}

class HTTPManager {
    static func post<T: Codable, U: Codable>(
        path: String,
        body: T
    ) async throws -> U {
        // Validar URL
        guard let url = URL(string: "\(BASE_URL)\(path)") else {
            throw URLError(.badURL)
        }
        
        // Configurar la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        // Realizar la solicitud
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        // Validar respuesta HTTP
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw URLError(.badServerResponse, userInfo: ["statusCode": statusCode])
        }
        
        // Decodificar la respuesta
        let decodedResponse = try JSONDecoder().decode(U.self, from: responseData)
        return decodedResponse
    }
    
    static func get<U: Codable>(
        path: String
    ) async throws -> U {
        // Validar URL
        guard let url = URL(string: "\(BASE_URL)\(path)") else {
            throw URLError(.badURL)
        }
        
        // Configurar la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Realizar la solicitud
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        // Validar respuesta HTTP
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw URLError(.badServerResponse, userInfo: ["statusCode": statusCode])
        }
        
        // Decodificar la respuesta
        let decodedResponse = try JSONDecoder().decode(U.self, from: responseData)
        return decodedResponse
    }
}
