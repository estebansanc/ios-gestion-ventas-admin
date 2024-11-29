//
//  CartView.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject private var viewModel: CartViewModel
    @Binding var path: NavigationPath
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            if viewModel.sell.sellLines.isEmpty {
                ContentUnavailableView(
                    "Tu carrito está vacío",
                    systemImage: "cart",
                    description: Text("Aún no tienes productos en tu carrito. ¡Empieza a comprar!").font(.caption)
                )
            } else {
                ForEach(viewModel.sell.sellLines, id: \.id) { line in
                    sellLineView(for: line)
                }
                .onDelete { index in
                    withAnimation {
                        viewModel.delete(at: index)
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            totalView
        }
        .task {
            await viewModel.fetchDiscounts()
        }
        .toolbar {
            Button("Volver", systemImage: "chevron.down.circle") {
                dismiss()
            }
            .buttonStyle(.bordered)
            .labelStyle(.titleAndIcon)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Carrito")
    }
    
    var totalView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 16) {
                Text("Total:")
                    .font(.title2)
                Text("\(viewModel.sell.total.formatted(.currency(code: "ARS")))")
                    .contentTransition(.numericText())
                    .font(.title2)
                    .strikethrough(
                        viewModel.discountApplied,
                        pattern: .solid,
                        color: .accentColor
                    )
                if viewModel.discountApplied {
                    Text("\(viewModel.updatedTotal.formatted(.currency(code: "ARS")))")
                        .contentTransition(.numericText())
                        .font(.footnote)
                }
            }
            .fontWeight(.bold)
            
            HStack {
                HStack {
                    Text("Descuento:")
                    Picker("Descuento", systemImage: "percent", selection: $viewModel.selectedDiscountID.animation()) {
                        Text("Ninguno")
                            .tag(-1)
                        ForEach(viewModel.discounts, id: \.id) { item in
                            VStack {
                                Text(item.percentage)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                Text(item.description)
                                    .font(.caption)
                            }
                            .tag(item.id)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .disabled(viewModel.sell.sellLines.isEmpty)
                
                Spacer()
                if viewModel.sell.total > 0 {
                    Button {
                        path.append(Route.checkout(sell: viewModel.sell))
                    } label: {
                        Label("Pagar", systemImage: "chevron.right.circle")
                            .labelStyle(.titleAndIcon)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .foregroundStyle(Color.accentColor)
        .padding()
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .accentColor.opacity(0.3), radius: 15, y: 10)
        .padding()
    }
    
    @ViewBuilder
    func sellLineView(for line: SellLine) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(line.product.name)")
                }
                Text("\(line.product.price.formatted(.currency(code: "ARS"))) / Unidad")
                    .font(.footnote)
                HStack(alignment: .bottom) {
                    Text("Cantidad:")
                        .font(.footnote)
                    Text("x\(line.count)")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("Subtotal:")
                        .font(.footnote)
                    Text("\(line.subtotal.formatted(.currency(code: "ARS")))")
                        .fontWeight(.bold)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
