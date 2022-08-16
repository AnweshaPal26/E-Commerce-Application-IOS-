//
//  CartResponse.swift
//  Frashly
//
//

import Foundation

struct Carts: Codable {
    var pid: String
    var qty, bundlePrice, price: Int
}

struct CartAddRequest: Codable {
    var pid: String
    var qty,price: Int
    
}



class Cartproducts {
    var pid, img, name: String
    var qty, bundlePrice: Int
    var price: Float
    
    init(pid:String, img:String, name:String, qty:Int, bundlePrice:Int, price:Float) {
        self.pid = pid
        self.img = img
        self.name = name
        self.qty = qty
        self.bundlePrice = bundlePrice
        self.price = price
    }
}

struct CartDeleteRequest: Codable {
    
    let index: String
}
