//
//  CheckoutView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject private var cartViewModel: CartViewModel
    @StateObject var viewModel = CheckoutViewModel()
    @FocusState private var isTextFieldFocused: Bool
    @Binding var path: NavigationPath
    @State var sell: Sell
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            paymentMethodPicker
            
            switch viewModel.paymentMethod {
            case .cash:
                paymentSection
            case .card:
                cardSection
            }
            
            clientSection
        }
        .safeAreaInset(edge: .bottom) {
            totalView
        }
        .disabled(viewModel.isLoading)
        .toolbar {
            if isTextFieldFocused {
                Button("Done") {
                    isTextFieldFocused = false
                }
            }
        }
        .navigationTitle("Pagar")
        .onAppear {
            viewModel.load(sell: sell)
        }
        .task {
            await viewModel.fetchClients()
            await viewModel.fetchDiscounts()
        }
        .alert("Venta exitosa!", isPresented: $viewModel.successSell) {
            Button("Volver al inicio") {
                cartViewModel.cleanSell()
                path = NavigationPath()
            }
        }
    }
    
    var paymentMethodPicker: some View {
        Picker("Método de pago", selection: $viewModel.paymentMethod.animation(.bouncy)) {
            ForEach(PaymentMethods.allCases, id: \.self) { method in
                Text(method.rawValue)
                    .tag(method)
            }
        }
    }
    
    var clientSection: some View {
        Section("Datos del cliente") {
            Picker("Cliente", selection: $viewModel.selectedClientID.animation()) {
                Text("Ninguno")
                    .tag(-1)
                ForEach(viewModel.clients, id: \.id) { item in
                    Text(item.name)
                        .tag(item.id)
                }
            }
            
            if let client = viewModel.selectedClient {
                Text("Nombre: \(client.name)")
                    .contentTransition(.numericText())
                Text("Apellido: \(client.lastname)")
                    .contentTransition(.numericText())
                Text("Email: \(client.email)")
                    .contentTransition(.numericText())
                Text("DNI: \(client.dni)")
                    .contentTransition(.numericText())
            }
        }
    }
    
    var cardSection: some View {
        Section("Datos de tarjeta") {
            TextField("Número", text: $viewModel.cardNumber)
                .textContentType(.creditCardNumber)
                .focused($isTextFieldFocused)
            TextField("Nombre", text: $viewModel.cardName)
                .textContentType(.creditCardName)
                .focused($isTextFieldFocused)
            HStack {
                TextField("CVV", text: $viewModel.cardCvv)
                    .textContentType(.creditCardSecurityCode)
                    .focused($isTextFieldFocused)
                TextField("Fecha", text: $viewModel.cardDate)
                    .textContentType(.creditCardExpiration)
                    .focused($isTextFieldFocused)
            }
        }
    }
    
    var paymentSection: some View {
        Section("Datos de pago") {
            TextField("Monto", value: $viewModel.amount.animation(), format: .currency(code: "ARS"))
                .focused($isTextFieldFocused)
                .keyboardType(.numberPad)
            Text("Vuelto: \(viewModel.returnAmount.formatted(.currency(code: "ARS")))")
        }
    }
    
    var totalView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 16) {
                Text("Total:")
                    .font(.title2)
                Text("\(viewModel.total.formatted(.currency(code: "ARS")))")
                    .contentTransition(.numericText())
                    .font(.title2)
                    .strikethrough(
                        viewModel.discountApplied,
                        pattern: .solid,
                        color: .accentColor
                    )
                if viewModel.discountApplied {
                    Text("\(viewModel.updatedTotal.formatted(.currency(code: "ARS")))")
                        .contentTransition(.numericText())
                        .font(.footnote)
                }
            }
            .fontWeight(.bold)
            
            HStack {
                Text("Descuento: \(viewModel.selectedDiscount?.percentage ?? "---")")
                
                Spacer()
                
                Button("Confirmar", systemImage: "chevron.right.circle") {
                    Task {
                        await viewModel.pay()
                    }
                }
                .buttonStyle(.borderedProminent)
                .font(.title3)
                .disabled(!viewModel.isInputValid)
                .fontWeight(.bold)
            }
        }
        .padding()
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .accentColor.opacity(0.2), radius: 25, y: 10)
        .padding()
    }
}
