//
//  AddProductView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 20/11/2024.
//

import SwiftUI

struct CreateProductRequest: Codable {
    let nombre: String
    let categoria: String
    let precio: Double
    let idGerente: String
    let tiempoFinSoporte: String
    let stock: Int
}

class AddProductViewModel: ObservableObject {
    @Published private(set) var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var name: String = ""
    @Published var price: String = ""
    @Published var category: String = ""
    @Published var supportEndTime: Date = .init()
    
    @MainActor
    func createProduct() async {
        isLoading = true
        guard let url = URL(string: "\(BASE_URL)/productos/crearproducto") else {
            showError(message: "Invalid URL")
            return
        }
        
        do {
            let body = CreateProductRequest(
                nombre: name,
                categoria: category,
                precio: Double(price) ?? 0,
                idGerente: "123",
                tiempoFinSoporte: DateFormatter().string(from: supportEndTime),
                stock: 0
            )
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            withAnimation {
                self.isSuccess = true
            }
        } catch {
            showError(message: error.localizedDescription)
        }
        isLoading = false
    }
    
    @MainActor
    private func showError(message: String) {
        isLoading = false
        print("Error: \(message)")
        self.errorMessage = message
    }
}

struct AddProductView: View {
    @StateObject private var viewModel = AddProductViewModel()
    @FocusState private var isTextFieldFirstResponder: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    LoadingView()
                } else {
                    Form {
                        Section("Datos del producto") {
                            TextField("Nombre", text: $viewModel.name)
                            TextField("Categoria", text: $viewModel.category)
                            TextField("Precio", text: $viewModel.price)
                                .keyboardType(.asciiCapableNumberPad)
                                .focused($isTextFieldFirstResponder)
                            DatePicker("Finalización de soporte", selection: $viewModel.supportEndTime, displayedComponents: .date)
                        }
                        
                        Button {
                            Task {
                                await viewModel.createProduct()
                            }
                        } label: {
                            Label("Crear", systemImage: "plus.circle")
                                .frame(height: 56)
                                .frame(maxWidth: .infinity)
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                }
            }
            .onChange(of: viewModel.isSuccess) { oldValue, newValue in
                if newValue {
                    dismiss()
                }
            }
            .alert(
                viewModel.errorMessage,
                isPresented: .init(
                    get: { !viewModel.errorMessage.isEmpty },
                    set: { _ in }
                )
            ) { }
            .toolbar {
                if isTextFieldFirstResponder {
                    Button("Done") {
                        isTextFieldFirstResponder = false
                    }
                }
            }
            .navigationTitle("Crear producto")
        }
    }
}

#Preview {
    AddProductView()
}
