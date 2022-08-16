//
//  OrderDetailsRequest.swift
//  Frashly
//
//

import Foundation

struct Order: Codable {
    let items: [Item]
    let orderedAt: String
    let total: Float
    let id: String
    let deliveryAddress: String
}

struct Item: Codable {
    let qty: Int
    let pid: String
    let bundlePrice,price: Float
}

struct OrderItems{
    let name,img: String
    let qty: Int
    let price: Float

}

struct PlaceOrder: Codable {
    let uid: String
    let deliveryAddress: String
}



