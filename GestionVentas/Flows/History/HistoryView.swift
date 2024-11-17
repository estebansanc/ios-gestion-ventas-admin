//
//  HistoryView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct Movement: Identifiable, Hashable {
    var id: Int
    var product: Product
    var count: Int
    var total: Double
    var date: Date
    var sellerName: String
    var clientName: String
}

struct HistoryView: View {
    @State var movements: [Movement] = mockMovements
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(movements, id: \.id) { movement in
                    NavigationLink(value: movement) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("$ \(movement.total.formatted())")
                                Spacer()
                                Text(movement.date.formatted(date: .numeric, time: .omitted))
                                    .font(.footnote)
                            }
                            .fontWeight(.bold)
                            
                            Group {
                                Text("\(movement.product.title) x\(movement.count)")
                                Text("Vendedor: \(movement.sellerName)")
                                Text("Cliente: \(movement.clientName)")
                            }
                            .font(.footnote)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .navigationDestination(for: Movement.self) { movement in
                Text(movement.product.title)
            }
            .navigationTitle("Historial")
        }
    }
}

#Preview {
    HistoryView()
}
