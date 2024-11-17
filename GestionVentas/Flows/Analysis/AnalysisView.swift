//
//  AnalysisView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct AnalysisView: View {
    @State private var fromDate: Date = .init()
    @State private var toDate: Date = .init()
    @State private var softwareType: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    DatePicker("Desde", selection: $fromDate, displayedComponents: .date)
                    DatePicker("Hasta", selection: $toDate, displayedComponents: .date)
                    Divider()
                    HStack {
                        Text("Producto")
                        Spacer()
                        Picker("Producto", systemImage: "chevron.down", selection: $softwareType) {
                            ForEach(1..<5) { index in
                                Text("Software \(index)")
                                    .tag("Software \(index)")
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 25)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Análisis")
        }
    }
}

#Preview {
    AnalysisView()
}
