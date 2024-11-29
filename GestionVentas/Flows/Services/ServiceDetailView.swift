//
//  ServiceDetailView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import SwiftUI

struct ServiceDetailView: View {
    @StateObject private var viewModel = ServiceDetailViewModel()
    @Environment(\.dismiss) var dismiss
    @State var selectedService: Service? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Group {
                    TextField("Nombre", text: $viewModel.name)
                    TextField("Precio", text: $viewModel.price)
                        .keyboardType(.asciiCapableNumberPad)
                    TextField("Categoria", text: $viewModel.category)
                    TextField("Comentarios", text: $viewModel.comments)
                    TextField("ID del Gerente", text: $viewModel.managerID)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                
                Button {
                    Task {
                        if selectedService != nil {
                            await viewModel.updateService()
                        } else {
                            await viewModel.createService()
                        }
                    }
                } label: {
                    Label(viewModel.buttonText, systemImage: "plus.circle")
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
            .padding()
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("Dismiss") {
                    viewModel.error = nil
                }
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
            .onChange(of: viewModel.dismiss) { oldValue, newValue in
                if newValue {
                    dismiss()
                }
            }
            .onAppear {
                viewModel.set(selectedService: selectedService)
            }
        }
    }
}
