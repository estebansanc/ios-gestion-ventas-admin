//
//  SettingsView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    SellersView()
                } label: {
                    Label("Gestionar Vendedores", systemImage: "person.fill")
                }
                
                NavigationLink {
                    Text("Gestionar Clientes")
                } label: {
                    Label("Gestionar Clientes", systemImage: "person.fill")
                }
                
                NavigationLink {
                    Text("Gestionar Gerentes")
                } label: {
                    Label("Gestionar Gerentes", systemImage: "person.fill")
                }
                
                NavigationLink {
                    Text("Gestionar Productos y Servicios")
                } label: {
                    Label("Gestionar Productos y Servicios", systemImage: "shippingbox")
                }
                
                NavigationLink {
                    Text("Gestionar Descuentos")
                } label: {
                    Label("Gestionar Descuentos", systemImage: "dollarsign.circle")
                }

            }
            .navigationTitle("Gestionar")
        }
    }
}

#Preview {
    SettingsView()
}
