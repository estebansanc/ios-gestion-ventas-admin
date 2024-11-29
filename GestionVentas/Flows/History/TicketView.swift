//
//  TicketView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

struct TicketView: View {
    @State var movement: Movement
    
    var body: some View {
        List {
            Section("Datos del Cliente") {
                Text("Cliente: \(movement.clientName)")
            }
            
            Section("Datos del Vendedor") {
                Text("Vendedor: \(movement.sellerName)")
            }
            
            Section("Lineas de venta") {
                ForEach(movement.sellLines) { line in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(line.productName)
                        HStack(alignment: .bottom) {
                            Text("\(line.productPrecio)/U.")
                            Spacer()
                            Text("x\(line.count)")
                            Spacer()
                            Text("Subtotal \(line.subtotal)")
                        }
                    }
                    .font(.caption)
                }
            }
            
            let paymentDetails = movement.paymentDetails
            
            Section("Datos del pago") {
                HStack {
                    Text("Método de pago")
                    Spacer()
                    Text(paymentDetails.paymentMethod.capitalized)
                }
                
                if paymentDetails.cashPaymentDetails.amount != nil {
                    let cashPaymentDetails = paymentDetails.cashPaymentDetails
                    HStack {
                        Text("Monto recibido")
                        Spacer()
                        Text(cashPaymentDetails.amount ?? "")
                    }
                    .font(.caption)
                    HStack {
                        Text("Vuelto")
                        Spacer()
                        Text(cashPaymentDetails.returned ?? "")
                    }
                    .font(.caption)
                } else if paymentDetails.cardDetails.name != nil {
                    let cardDetails = paymentDetails.cardDetails
                    HStack {
                        Text("Tarjeta")
                        Spacer()
                        Text(cardDetails.name ?? "")
                        Text(cardDetails.number ?? "")
                        Text(cardDetails.expirationDate ?? "")
                    }
                    .font(.caption)
                }
            }
        }
        .navigationTitle("Ticket")
    }
}
