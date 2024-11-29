//
//  ClientDetailView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import SwiftUI

struct ClientDetailView: View {
    @StateObject private var viewModel = ClientDetailViewModel()
    @Environment(\.dismiss) var dismiss
    @State var selectedClient: Client? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Group {
                    TextField("Nombre", text: $viewModel.name)
                    TextField("Apellido", text: $viewModel.lastname)
                    TextField("Email", text: $viewModel.email)
                    TextField("DNI", text: $viewModel.dni)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                
                Button {
                    Task {
                        if selectedClient != nil {
                            await viewModel.updateClient()
                        } else {
                            await viewModel.createClient()
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
                viewModel.set(selectedClient: selectedClient)
            }
        }
    }
}
