//
//  SellersView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 17/11/2024.
//

import SwiftUI

struct Seller: Identifiable {
    let id: String = UUID().uuidString
    let fullName: String
}

struct SellersView: View {
    @State private var sellers: [Seller] = []
    
    var body: some View {
        List {
            ForEach(sellers, id: \.id) { seller in
                Text(seller.fullName)
            }
        }
        .navigationTitle("Vendedores")
    }
}

#Preview {
    SellersView()
}
