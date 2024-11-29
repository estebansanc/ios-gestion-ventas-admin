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
                    ServicesView()
                } label: {
                    Label("Gestionar Productos", systemImage: "shippingbox")
                }
                
                NavigationLink {
                    DiscountsView()
                } label: {
                    Label("Gestionar Descuentos", systemImage: "dollarsign.circle")
                }

                
                NavigationLink {
                    List {
                        VStack(alignment: .leading) {
                            Text("Casacci, Luciano Esteban")
                                .fontWeight(.bold)
                            Text("Legajo: 52732")
                        }
                        VStack(alignment: .leading) {
                            Text("Fuentes García, Franco Nicolás")
                                .fontWeight(.bold)
                            Text("Legajo: 52503")
                        }
                        VStack(alignment: .leading) {
                            Text("Moreno Ivanoff, Jeremías")
                                .fontWeight(.bold)
                            Text("Legajo: 52473")
                        }
                        VStack(alignment: .leading) {
                            Text("Rocha, Felipe")
                                .fontWeight(.bold)
                            Text("Legajo: 52655")
                        }
                        VStack(alignment: .leading) {
                            Text("Sánchez, Esteban Nicolás")
                                .fontWeight(.bold)
                            Text("Legajo: 49894")
                        }
                    }
                    .navigationTitle("Créditos")
                } label: {
                    Label {
                        Text("Créditos")
                            .fontWeight(.bold)
                    } icon: {
                        Image(.utnLogo)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .navigationTitle("Gestionar")
        }
    }
}

#Preview {
    SettingsView()
}
