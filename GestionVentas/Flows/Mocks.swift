//
//  Mocks.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import Foundation

let BASE_URL: String = "https://backendadmin.lunahri.net.ar"

//let mockProducts: [Product] = [
//    Product(title: "Camiseta Casual", subtitle: "Camiseta de algodón 100%", price: 19.99),
//    Product(title: "Pantalones Jeans", subtitle: "Jeans azul clásico", price: 49.99),
//    Product(title: "Zapatillas Deportivas", subtitle: "Zapatillas cómodas para correr", price: 69.99),
//    Product(title: "Chaqueta de Cuero", subtitle: "Chaqueta de cuero sintético", price: 89.99),
//    Product(title: "Gorra de Béisbol", subtitle: "Gorra ajustable unisex", price: 14.99),
//    Product(title: "Mochila Casual", subtitle: "Mochila para el uso diario", price: 39.99),
//    Product(title: "Gafas de Sol", subtitle: "Gafas de sol con protección UV", price: 24.99),
//    Product(title: "Bufanda de Lana", subtitle: "Bufanda cálida para invierno", price: 12.99),
//    Product(title: "Reloj de Pulsera", subtitle: "Reloj analógico con correa de cuero", price: 59.99),
//    Product(title: "Camisa Formal", subtitle: "Camisa de vestir para ocasiones especiales", price: 29.99)
//]
//
let mockSells: [Sell] = [
//    Sell(sellLines: [
//        SellLine(count: 2, product: mockProducts[0]),
//        SellLine(count: 1, product: mockProducts[1])
//    ], paymentDetails: PaymentDetails(paymentMethod: .cash, cardDetails: nil, cashPaymentDetails: CashPaymentDetails(amount: 100, returned: 30.02), date: Date()), sellerName: "Juan Pérez", clientName: "Ana López", date: Date()),
//    Sell(sellLines: [
//        SellLine(count: 1, product: mockProducts[2]),
//        SellLine(count: 3, product: mockProducts[3])
//    ], paymentDetails: PaymentDetails(paymentMethod: .card, cardDetails: CardDetails(number: "1234 5678 9101 1121", name: "María González", securityCode: "123", expirationDate: "12/25"), cashPaymentDetails: nil, date: Date()), sellerName: "Pedro Martínez", clientName: "Laura Fernández", date: Date()),
//    Sell(sellLines: [
//        SellLine(count: 5, product: mockProducts[4]),
//        SellLine(count: 2, product: mockProducts[5])
//    ], paymentDetails: PaymentDetails(paymentMethod: .card, cardDetails: CardDetails(number: "9876 5432 1098 7654", name: "Lucía Torres", securityCode: "456", expirationDate: "11/26"), cashPaymentDetails: nil, date: Date()), sellerName: "Javier Díaz", clientName: "Sofía Rivas", date: Date())
]

let mockMovements: [Movement] = [
//    Movement(sell: mockSells[0]),
//    Movement(sell: mockSells[1]),
//    Movement(sell: mockSells[2])
]

let mockSellLines: [SellLine] = [
//    SellLine(count: 3, product: mockProducts[0]),
//    SellLine(count: 2, product: mockProducts[1]),
//    SellLine(count: 1, product: mockProducts[2]),
//    SellLine(count: 1, product: mockProducts[3]),
//    SellLine(count: 5, product: mockProducts[4]),
//    SellLine(count: 2, product: mockProducts[5]),
//    SellLine(count: 4, product:  mockProducts[6]),
//    SellLine(count: 3, product: mockProducts[7]),
//    SellLine(count: 1, product: mockProducts[8]),
//    SellLine(count: 2, product: mockProducts[9])
]
