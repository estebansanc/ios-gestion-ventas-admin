//
//  DiscountsView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

struct Discount: Identifiable, Hashable, Codable {
    let id: Int
    let description: String
    let percentage: String
    let expirationDate: Date
    let managerID: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "idDescuento"
        case description = "descripcion"
        case percentage = "porcentajeDescuento"
        case expirationDate = "fechaCaducidad"
        case managerID = "idGerente"
    }
}

struct DiscountsView: View {
    @StateObject private var viewModel = DiscountsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Toggle("Solo descuentos validos", isOn: $viewModel.onlyValid)
                
                ForEach(viewModel.discounts, id: \.id) { item in
                    NavigationLink {
                        DiscountDetailView(selectedDiscount: item)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.description)
                                .fontWeight(.bold)
                            Group {
                                Text("Porcentaje: %\(item.percentage)")
                                Text("Expiración: \(item.expirationDate.formatted())")
                            }
                            .font(.footnote)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        DiscountDetailView()
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                }
            }
            .task {
                await viewModel.fetchDiscounts()
            }
            .refreshable {
                await viewModel.fetchDiscounts()
            }
            .onChange(of: viewModel.onlyValid) { oldValue, newValue in
                Task {
                    await viewModel.fetchDiscounts()
                }
            }
            .navigationTitle("Descuentos")
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("Dismiss") {
                    viewModel.error = nil
                }
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    DiscountsView()
}
