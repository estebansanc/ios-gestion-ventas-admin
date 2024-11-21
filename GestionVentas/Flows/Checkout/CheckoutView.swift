//
//  CheckoutView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

enum PaymentMethods: String, CaseIterable {
    case cash = "Efectivo"
    case card = "Tarjeta"
}

struct CardDetails: Hashable {
    let id: String = UUID().uuidString
    let number: String
    let name: String
    let securityCode: String
    let expirationDate: String
}

struct CashPaymentDetails: Hashable {
    let id: String = UUID().uuidString
    let amount: Double
    let returned: Double
}

struct PaymentDetails: Hashable {
    let id: String = UUID().uuidString
    let paymentMethod: PaymentMethods
    let cardDetails: CardDetails?
    let cashPaymentDetails: CashPaymentDetails?
    let date: Date
    
    static func == (lhs: PaymentDetails, rhs: PaymentDetails) -> Bool {
        return lhs.id == rhs.id
    }
}

struct CheckoutView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @State var paymentMethod: PaymentMethods = .cash
    @State var cardNumber: String = ""
    @State var cardName: String = ""
    @State var cardCvv: String = ""
    @State var cardDate: String = ""
    @State var amount: String = "" {
        didSet {
            calculateReturn()
        }
    }
    @State var returnAmount: Double = 0
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        Form {
            paymentMethodPicker
            
            switch paymentMethod {
            case .cash:
                paymentSection
            case .card:
                cardSection
            }
        }
        .safeAreaInset(edge: .bottom) {
            totalView
        }
        .toolbar {
            if isTextFieldFocused {
                Button("Done") {
                    isTextFieldFocused = false
                }
            }
        }
        .navigationTitle("Pagar")
    }
    
    var paymentMethodPicker: some View {
        Picker("Método de pago", selection: $paymentMethod.animation(.bouncy)) {
            ForEach(PaymentMethods.allCases, id: \.self) { method in
                Text(method.rawValue)
                    .tag(method)
            }
        }
    }
    
    var cardSection: some View {
        Section("Datos de tarjeta") {
            TextField("Número", text: $cardNumber)
                .textContentType(.creditCardNumber)
                .focused($isTextFieldFocused)
            TextField("Nombre", text: $cardName)
                .textContentType(.creditCardName)
                .focused($isTextFieldFocused)
            HStack {
                TextField("CVV", text: $cardCvv)
                    .textContentType(.creditCardSecurityCode)
                    .focused($isTextFieldFocused)
                TextField("Fecha", text: $cardDate)
                    .textContentType(.creditCardExpiration)
                    .focused($isTextFieldFocused)
            }
        }
    }
    
    var paymentSection: some View {
        Section("Datos de pago") {
            TextField("Monto", text: $amount.animation())
                .focused($isTextFieldFocused)
                .keyboardType(.numberPad)
            Text("Vuelto: \(returnAmount.formatted())")
        }
    }
    
    var totalView: some View {
        HStack {
            Group {
                Text("Total: \(cartViewModel.sell.total.formatted())")
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
                Spacer()
                Button("Confirmar", systemImage: "chevron.right.circle") {
                    switch paymentMethod {
                    case .card:
                        cartViewModel.updateCardPayment(
                            number: cardNumber,
                            name: cardName,
                            securityCode: cardCvv,
                            expirationDate: cardDate
                        )
                    case .cash:
                        cartViewModel.updateCashPayment(
                            amount: amount,
                            returnAmount: returnAmount
                        )
                    }
                }
                .buttonStyle(.borderedProminent)
                .font(.title3)
            }
            .fontWeight(.bold)
        }
        .padding()
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .accentColor.opacity(0.2), radius: 25, y: 10)
        .padding()
    }
    
    func calculateReturn() {
        guard let amount = Double(amount) else {
            returnAmount = 0
            return
        }
        returnAmount = max(amount - cartViewModel.sell.total, 0)
    }
}

#Preview {
    NavigationStack {
        CheckoutView()
            .environmentObject(CartViewModel())
    }
}
