//
//  DiscountDetailView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 28/11/2024.
//

import SwiftUI

struct DiscountDetailView: View {
    @StateObject private var viewModel = DiscountDetailViewModel()
    @Environment(\.dismiss) var dismiss
    @State var selectedDiscount: Discount? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Group {
                    TextField("Descripcion", text: $viewModel.description)
                    TextField("Porcentaje", value: $viewModel.percentage, format: .percent)
                        .keyboardType(.asciiCapableNumberPad)
                    TextField("ID del Gerente", text: $viewModel.managerID)
                    DatePicker("Fecha de expiración", selection: $viewModel.expirationDate)
                        .datePickerStyle(CompactDatePickerStyle())
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                
                Button {
                    Task {
                        if selectedDiscount != nil {
                            await viewModel.updateDiscount()
                        } else {
                            await viewModel.createDiscount()
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
                viewModel.set(selectedDiscount: selectedDiscount)
            }
        }
    }
}
