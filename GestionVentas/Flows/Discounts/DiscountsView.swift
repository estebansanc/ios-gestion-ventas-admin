//
//  DiscountsView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 21/11/2024.
//

import SwiftUI

struct Discount: Identifiable, Codable {
    let id: Int
    let descripcion: String
    let porcentajeDescuento: String
    let idGerente: String
    let fechaCaducidad: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id_descuento"
        case descripcion
        case porcentajeDescuento
        case idGerente
        case fechaCaducidad
    }
}

class DiscountsViewModel: ObservableObject {
    @Published private(set) var discounts: [Discount] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    @MainActor
    func fetchDiscounts() async {
        isLoading = true
        
        do {
            let result: [Discount] = try await HTTPManager.get(path: "/descuentos")
            withAnimation {
                self.discounts = result
            }
        } catch {
            debugPrint(error)
            showError(message: error.localizedDescription)
        }
        isLoading = false
    }
    
    @MainActor
    private func showError(message: String) {
        print("Error: \(message)")
        self.errorMessage = message
    }
}

struct DiscountsView: View {
    @StateObject private var viewModel = DiscountsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.discounts, id: \.id) { discount in
                VStack(alignment: .leading) {
                    Text(discount.descripcion)
                        .fontWeight(.bold)
                    HStack {
                        Text(discount.porcentajeDescuento)
                        Text(discount.fechaCaducidad)
                    }
                }
            }
        }
        .toolbar {
            NavigationLink {
                Form {
                    Section("Datos del descuento") {
                        Text("Descripcion")
                        Text("Porcentaje de descuento")
                        Text("Fecha de caducidad")
                    }
                    
                    Label("Crear", systemImage: "plus.circle")
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .navigationTitle("Agregar descuento")
            } label: {
                Label("Agregar", systemImage: "plus.circle")
            }
        }
        .alert(
            viewModel.errorMessage,
            isPresented: .init(
                get: { !viewModel.errorMessage.isEmpty },
                set: { _ in viewModel.errorMessage = "" }
            ),
            actions: {}
        )
        .onAppear {
            Task {
                await viewModel.fetchDiscounts()
            }
        }
        .refreshable {
            await viewModel.fetchDiscounts()
        }
        .navigationTitle("Descuentos")
    }
}

#Preview {
    DiscountsView()
}
