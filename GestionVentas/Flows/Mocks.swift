//
//  Mocks.swift
//  GestionVentas
//
//  Created by Esteban Sánchez on 16/11/2024.
//

import Foundation

var mockProducts: [Product] = [
    Product(id: 1, title: "Camiseta Casual", subtitle: "Camiseta de algodón 100%", price: 19.99),
    Product(id: 2, title: "Pantalones Jeans", subtitle: "Jeans azul clásico", price: 49.99),
    Product(id: 3, title: "Zapatillas Deportivas", subtitle: "Zapatillas cómodas para correr", price: 69.99),
    Product(id: 4, title: "Chaqueta de Cuero", subtitle: "Chaqueta de cuero sintético", price: 89.99),
    Product(id: 5, title: "Gorra de Béisbol", subtitle: "Gorra ajustable unisex", price: 14.99),
    Product(id: 6, title: "Mochila Casual", subtitle: "Mochila para el uso diario", price: 39.99),
    Product(id: 7, title: "Gafas de Sol", subtitle: "Gafas de sol con protección UV", price: 24.99),
    Product(id: 8, title: "Bufanda de Lana", subtitle: "Bufanda cálida para invierno", price: 12.99),
    Product(id: 9, title: "Reloj de Pulsera", subtitle: "Reloj analógico con correa de cuero", price: 59.99),
    Product(id: 10, title: "Camisa Formal", subtitle: "Camisa de vestir para ocasiones especiales", price: 29.99)
]

let mockMovements: [Movement] = [
    Movement(id: 1, product: mockProducts[0], count: 3, total: 59.97, date: Date(), sellerName: "Juan Pérez", clientName: "Ana López"),
    Movement(id: 2, product: mockProducts[1], count: 2, total: 99.98, date: Date(), sellerName: "María González", clientName: "Carlos Gómez"),
    Movement(id: 3, product: mockProducts[2], count: 1, total: 69.99, date: Date(), sellerName: "Pedro Martínez", clientName: "Laura Fernández"),
    Movement(id: 4, product: mockProducts[3], count: 1, total: 89.99, date: Date(), sellerName: "Lucía Torres", clientName: "Miguel Ramírez"),
    Movement(id: 5, product: mockProducts[4], count: 5, total: 74.95, date: Date(), sellerName: "Javier Díaz", clientName: "Sofía Rivas"),
    Movement(id: 6, product: mockProducts[5], count: 2, total: 79.98, date: Date(), sellerName: "Carla López", clientName: "Diego Sánchez"),
    Movement(id: 7, product: mockProducts[6], count: 4, total: 99.96, date: Date(), sellerName: "Fernando Ruiz", clientName: "Valeria Castro"),
    Movement(id: 8, product: mockProducts[7], count: 3, total: 38.97, date: Date(), sellerName: "Nicolás Vega", clientName: "Patricia Mora"),
    Movement(id: 9, product: mockProducts[8], count: 1, total: 59.99, date: Date(), sellerName: "Andrea Navarro", clientName: "Ricardo Ortiz"),
    Movement(id: 10, product: mockProducts[9], count: 2, total: 59.98, date: Date(), sellerName: "Roberto Flores", clientName: "Gabriela Silva")
]
