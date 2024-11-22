//
//  AddProductView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 20/11/2024.
//

import SwiftUI

struct CreateProductRequest: Codable {
    let name: String
    let category: String
    let price: Double
    let idGerente: String
    let commentary: String
    
    enum CodingKeys: String, CodingKey {
        case name = "nombre"
        case category = "categoria"
        case price = "precio"
        case idGerente = "id_gerente"
        case commentary = "comentarios"
    }
}

struct CreateProductResponse: Codable {
    let message: String
}

class AddProductViewModel: ObservableObject {
    @Published private(set) var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var name: String = ""
    @Published var price: String = ""
    @Published var category: String = ""
    @Published var commentary: String = ""
    
    @MainActor
    func createProduct() async {
        isLoading = true
        
        do {
            let body = CreateProductRequest(
                name: name,
                category: category,
                price: Double(price) ?? 0,
                idGerente: "1",
                commentary: ""
            )
            let _: CreateProductResponse = try await HTTPManager.post(
                path: "/productos/crearproducto",
                body: body
            )
            
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
                            TextField("Comentarios", text: $viewModel.commentary)
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
