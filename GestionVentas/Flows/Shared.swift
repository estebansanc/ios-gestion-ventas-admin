//
//  Shared.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 21/11/2024.
//

import SwiftUI

extension Date {
    func convertDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func convertDateToISO8601String() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        return isoFormatter.string(from: self)
    }
}

class BaseViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    @MainActor
    func callService(_ serviceCall: () async throws -> Void) async {
        isLoading = true
        
        do {
            try await serviceCall()
        } catch {
            self.error = error
            debugPrint(error)
        }
        
        isLoading = false
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView("Cargando")
    }
}

class HTTPManager {
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
    }
    
    static func post<T: Codable, U: Codable>(
        path: String,
        body: T
    ) async throws -> U {
        debugPrint(body)
        return try await execute(
            path: path,
            httpMethod: .POST,
            body: body
        )
    }
    
    static func post<T: Codable, U: Codable>(
        absolutePath: String,
        body: T
    ) async throws -> U {
        debugPrint(body)
        return try await execute(
            absolutePath: absolutePath,
            httpMethod: .POST,
            body: body
        )
    }
    
    static func put<T: Codable, U: Codable>(
        path: String,
        body: T
    ) async throws -> U {
        debugPrint(body)
        return try await execute(
            path: path,
            httpMethod: .PUT,
            body: body
        )
    }
    
    static func get<U: Codable>(
        path: String
    ) async throws -> U {
        // Validar URL
        let url = try getURL(path: path)
        
        // Configurar la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Realizar la solicitud
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        // Validar respuesta HTTP
        try isValid(response: response)
        
        // Decodificar la respuesta
        let decodedResponse = try JSONDecoder().decode(U.self, from: responseData)
        return decodedResponse
    }
    
    static func execute<T: Codable, U: Codable>(
        absolutePath: String,
        httpMethod: HTTPMethod,
        body: T? = nil
    ) async throws -> U {
        // Validar URL
        guard let url = URL(string: absolutePath) else {
            throw URLError(.badURL)
        }
        print(url.absoluteString)
        
        // Configurar la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        // Realizar la solicitud
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        // Validar respuesta HTTP
        try isValid(response: response)
        
        // Decodificar la respuesta
        let decodedResponse = try JSONDecoder().decode(U.self, from: responseData)
        return decodedResponse
    }
    
    static func execute<T: Codable, U: Codable>(
        path: String,
        httpMethod: HTTPMethod,
        body: T? = nil
    ) async throws -> U {
        // Validar URL
        let url = try getURL(path: path)
        
        // Configurar la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        // Realizar la solicitud
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        // Validar respuesta HTTP
        try isValid(response: response)
        
        // Decodificar la respuesta
        let decodedResponse = try JSONDecoder().decode(U.self, from: responseData)
        return decodedResponse
    }
    
    static func isValid(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw URLError(.badServerResponse, userInfo: ["statusCode": statusCode])
        }
        return
    }
    
    static func getURL(path: String) throws -> URL {
        guard let url = URL(string: "\(BASE_URL)\(path)") else {
            throw URLError(.badURL)
        }
        print(url.absoluteString)
        return url
    }
}
