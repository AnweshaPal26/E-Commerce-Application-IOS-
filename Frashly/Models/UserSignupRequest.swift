//
//  UserSignupRequest.swift
//  Frashly
//
//

import Foundation

struct UserSignupRequest: Codable {
    
    let email, password, address, name, mobile: String
    
}
