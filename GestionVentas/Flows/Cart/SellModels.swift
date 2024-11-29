//
//  SellModels.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 29/11/2024.
//

import SwiftUI

enum SellRequest {
    struct Request: Codable {
        let idVendedor: String
        let idCliente: String
        let date: String
        let idDescuento: String?
        let total: Double
        let totalCount: Int
        let sellLines: [SellLine]
        let paymentDetails: PaymentDetails
    }
    
    struct SellLine: Codable {
        let count: Int
        let product: Product
        let subtotal: Double
    }
    
    struct Product: Codable {
        let id: String
    }
    
    struct PaymentDetails: Codable {
        let paymentMethod: PaymentMethods
        let cardDetails: CardDetails?
        let cashPaymentDetails: CashPaymentDetails?
        let date: String
    }
    
    enum PaymentMethods: String, Codable {
        case cash = "Efectivo"
        case card = "Tarjeta"
    }
    
    struct CardDetails: Codable {
        let number: String
        let name: String
        let securityCode: String
        let expirationDate: String
    }
    
    struct CashPaymentDetails: Codable {
        let amount : Double
        let returned: Double
    }
}

class SellRequestMapper {
    static func map(_ entity: Sell) -> SellRequest.Request {
        .init(
            idVendedor: entity.idVendedor,
            idCliente: entity.idCliente,
            date: entity.date.convertDateToISO8601String(),
            idDescuento: entity.idDescuento,
            total: entity.total,
            totalCount: entity.totalCount,
            sellLines: map(entity.sellLines),
            paymentDetails: map(entity.paymentDetails)
        )
    }
    
    static func map(_ entities: [SellLine]) -> [SellRequest.SellLine] {
        entities.map { map($0) }
    }
    
    static func map(_ entity: SellLine) -> SellRequest.SellLine {
        .init(
            count: entity.count,
            product: map(entity.product),
            subtotal: entity.subtotal
        )
    }
    
    static func map(_ entity: PaymentDetails) -> SellRequest.PaymentDetails {
        .init(
            paymentMethod: map(entity.paymentMethod),
            cardDetails: map(entity.cardDetails),
            cashPaymentDetails: map(entity.cashPaymentDetails),
            date: entity.date.convertDateToISO8601String()
        )
    }
    
    static func map(_ entity: Product) -> SellRequest.Product {
        .init(id: String(entity.id))
    }
    
    static func map(_ entity: PaymentMethods) -> SellRequest.PaymentMethods {
        switch entity {
        case .cash:
            return .cash
        case .card:
            return .card
        }
    }
    
    static func map(_ entity: CardDetails?) -> SellRequest.CardDetails? {
        guard let entity else { return nil }
        return .init(
            number: entity.number,
            name: entity.name,
            securityCode: entity.securityCode,
            expirationDate: entity.expirationDate
        )
    }
    
    static func map(_ entity: CashPaymentDetails?) -> SellRequest.CashPaymentDetails? {
        guard let entity else { return nil }
        return .init(
            amount: entity.amount,
            returned: entity.returned
        )
    }
}

struct Sell: Identifiable, Hashable {
    let id = UUID().uuidString
    var sellLines: [SellLine]
    var paymentDetails: PaymentDetails
    var idVendedor: String
    var idCliente: String
    var idDescuento: String? = nil
    var date: Date = .init()
    
    var total: Double {
        sellLines.reduce(0, { $0 + $1.subtotal })
    }
    
    var totalCount: Int {
        sellLines.reduce(0, { $0 + $1.count })
    }
    
    static func == (lhs: Sell, rhs: Sell) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SellLine: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var count: Int
    let product: Product
    
    var subtotal: Double {
        Double(count) * (product.price)
    }
}

enum PaymentMethods: String, CaseIterable {
    case cash = "Efectivo"
    case card = "Tarjeta"
}

struct CardDetails: Hashable {
    let id: String = UUID().uuidString
    let number: String
    let name: String
    let securityCode: String
    let expirationDate: String
}

struct CashPaymentDetails: Hashable {
    let id: String = UUID().uuidString
    let amount: Double
    let returned: Double
}

struct PaymentDetails: Hashable {
    let id: String = UUID().uuidString
    var paymentMethod: PaymentMethods
    var cardDetails: CardDetails?
    var cashPaymentDetails: CashPaymentDetails?
    var date: Date
    
    static func == (lhs: PaymentDetails, rhs: PaymentDetails) -> Bool {
        return lhs.id == rhs.id
    }
    
    static var initial: PaymentDetails {
        .init(
            paymentMethod: .cash,
            cashPaymentDetails: .init(amount: 0, returned: 0),
            date: Date()
        )
    }
}
