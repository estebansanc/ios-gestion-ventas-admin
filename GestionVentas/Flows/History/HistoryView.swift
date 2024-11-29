//
//  HistoryView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistorysViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.movements, id: \.id) { movement in
                    NavigationLink {
                        TicketView(movement: movement)
                    } label: {
                        movementItemView(movement)
                    }
                }
            }
            .refreshable {
                await viewModel.fetchHistorys()
            }
            .navigationTitle("Historial")
            .task {
                await viewModel.fetchHistorys()
            }
        }
    }
    
    @ViewBuilder
    func movementItemView(_ movement: Movement) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(movement.total)
                Spacer()
                Text(movement.date)
                    .font(.footnote)
            }
            .fontWeight(.bold)
            
            Group {
                Text("\(movement.sellLines.count) productos")
                Text("Vendedor: \(movement.sellerName)")
                Text("Cliente: \(movement.clientName)")
            }
            .font(.footnote)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HistoryView()
}
