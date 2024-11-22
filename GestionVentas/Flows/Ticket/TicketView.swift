//
//  TicketView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

struct TicketView: View {
    @State var sell: Sell
    
    var body: some View {
        List {
            Section("Datos del Cliente") {
                Text("Cliente: \(sell.clientName)")
            }
            
            Section("Datos del Vendedor") {
                Text("Vendedor: \(sell.sellerName)")
            }
            
            Section("Lineas de venta") {
                ForEach(sell.sellLines, id: \.id) { line in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(line.product.name)")
                        HStack(alignment: .bottom) {
                            Text("\(line.product.price.formatted(.currency(code: "ARS")))/U.")
                            Spacer()
                            Text("x\(line.count)")
                            Spacer()
                            Text("Subtotal \(line.subtotal.formatted())")
                        }
                    }
                }
            }
            
            if let paymentDetails = sell.paymentDetails {
                Section("Datos del pago") {
                    HStack {
                        Text("Método de pago")
                        Spacer()
                        Text("\(paymentDetails.paymentMethod.rawValue.capitalized)")
                    }
                    
                    if paymentDetails.paymentMethod == .cash {
                        HStack {
                            Text("Monto recibido")
                            Spacer()
                            Text("\(paymentDetails.cashPaymentDetails?.amount.formatted() ?? "---")")
                        }
                        HStack {
                            Text("Vuelto")
                            Spacer()
                            Text("\(paymentDetails.cashPaymentDetails?.returned.formatted() ?? "---")")
                        }
                    } else {
                        HStack {
                            Text("Tarjeta")
                            Spacer()
                            Text("•••• \(paymentDetails.cardDetails?.number.suffix(4) ?? "---")")
                        }
                    }
                }
            }
        }
        .navigationTitle("Ticket")
    }
}

#Preview {
    TicketView(sell: mockSells.first!)
}
