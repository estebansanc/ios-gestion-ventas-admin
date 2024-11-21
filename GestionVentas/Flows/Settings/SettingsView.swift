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
                    ClientsView()
                } label: {
                    Label("Gestionar Clientes", systemImage: "person.fill")
                }
                
                NavigationLink {
                    ManagersView()
                } label: {
                    Label("Gestionar Gerentes", systemImage: "person.fill")
                }
                
                NavigationLink {
                    List {
                        NavigationLink("Crear producto") {
                            AddProductView()
                        }
                    }
                    .navigationTitle("Gestionar Productos")
                } label: {
                    Label("Gestionar Productos", systemImage: "shippingbox")
                }
                
                NavigationLink {
                    DiscountsView()
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
