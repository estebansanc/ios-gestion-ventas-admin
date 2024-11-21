//
//  HistoryView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct Movement: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var sell: Sell
    
    static func == (lhs: Movement, rhs: Movement) -> Bool {
        return lhs.id == rhs.id
    }
}

struct HistoryView: View {
    @State var movements: [Movement] = mockMovements
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(movements, id: \.id) { movement in
                    NavigationLink(value: movement) {
                        movementItemView(movement)
                    }
                }
            }
            .navigationDestination(for: Movement.self) { movement in
                TicketView(sell: movement.sell)
            }
            .navigationTitle("Historial")
        }
    }
    
    @ViewBuilder
    func movementItemView(_ movement: Movement) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(movement.sell.total.formatted())")
                Spacer()
                Text(movement.sell.date.formatted(date: .numeric, time: .omitted))
                    .font(.footnote)
            }
            .fontWeight(.bold)
            
            Group {
//                Text("\(movement.product.title) x\(movement.count)")
                Text("Vendedor: \(movement.sell.sellerName)")
                Text("Cliente: \(movement.sell.clientName)")
            }
            .font(.footnote)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HistoryView()
}
