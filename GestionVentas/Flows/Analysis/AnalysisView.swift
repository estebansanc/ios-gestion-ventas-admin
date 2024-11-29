//
//  AnalysisView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct AnalysisView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    DatePicker("Desde", selection: $viewModel.fromDate.animation(), displayedComponents: .date)
                    Divider()
                    DatePicker("Hasta", selection: $viewModel.toDate.animation(), displayedComponents: .date)
                    if !viewModel.sellers.isEmpty {
                        Divider()
                        HStack {
                            Text("Vendedor")
                            Picker("Vendedor", selection: $viewModel.sellerID.animation()) {
                                Text("Todos")
                                    .tag(-1)
                                ForEach(viewModel.sellers, id: \.id) {
                                    Text($0.name)
                                        .tag($0.id)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
                
                AsyncImage(
                    url: URL(string: viewModel.imageUrlString)
                ) { transaction in
                    if let image = transaction.image {
                        image.resizable()
                            .scaledToFit()
                    } else if transaction.error != nil {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.gray.opacity(0.5))
                    } else {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.gray.opacity(0.5))
                            .overlay {
                                ProgressView()
                                    .tint(.white)
                            }
                    }
                }
                .contentTransition(.identity)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Análisis")
            .task {
                await viewModel.fetchSellers()
                await viewModel.fetchImage()
            }
            .onChange(of: viewModel.fromDate) { oldValue, newValue in
                Task {
                    await viewModel.fetchImage()
                }
            }
            .onChange(of: viewModel.toDate) { oldValue, newValue in
                Task {
                    await viewModel.fetchImage()
                }
            }
            .onChange(of: viewModel.sellerID) { oldValue, newValue in
                Task {
                    await viewModel.fetchImage()
                }
            }
        }
    }
}

#Preview {
    AnalysisView()
}
