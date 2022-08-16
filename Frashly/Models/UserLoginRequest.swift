//
//  UserLoginRequest.swift
//  Frashly
//
//

import Foundation

struct UserLoginRequest: Codable {
    
    let email, password: String
}

struct UserLoginResponse: Codable {
    let kind,localID, email, displayName: String
    let idToken: String
    let registered: Bool
    let refreshToken, expiresIn: String
    
    enum CodingKeys: String, CodingKey {
        case kind
        case localID = "localId"
        case email, displayName, idToken, registered, refreshToken, expiresIn
    }
}
