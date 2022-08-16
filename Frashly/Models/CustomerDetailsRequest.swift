//
//  CustomerDetailsRequest.swift
//  Frashly
//
//

import Foundation
struct Customer: Codable {
    let email: String
    let wishlist: [String]
    let cart: [CustomerCart]
    let name, address: String
    let orders: [CustomerOrder]
    let mobile: String
}

// MARK: - Cart
struct CustomerCart: Codable {
    let pid: String
    let price, bundlePrice, qty: Int
}

// MARK: - Order
struct CustomerOrder: Codable {
    let items: [CustomerCart]
    let orderedAt: String
    let total: Int
}

struct ResetPassword: Codable{
    let email: String
    let uid: String
}

struct PassResetResponse: Codable{
    let passwordResetLink: String
}

struct ChangeAdress: Codable{
    let uid, address: String
}


