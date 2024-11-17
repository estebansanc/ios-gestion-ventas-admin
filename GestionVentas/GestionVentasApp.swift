//
//  GestionVentasApp.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

@main
struct GestionVentasApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ProductsView()
                    .tabItem { Label("Productos", systemImage: "list.bullet") }
                HistoryView()
                    .tabItem { Label("Historial", systemImage: "clock.arrow.circlepath") }
                AnalysisView()
                    .tabItem { Label("Análsis", systemImage: "chart.line.uptrend.xyaxis") }
                SettingsView()
                    .tabItem { Label("Gestionar", systemImage: "gearshape.fill") }
            }
        }
    }
}
