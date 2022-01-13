//
//  User.swift
//  mBanking
//
//  Created by Borna Ungar on 12.01.2022..
//

import Foundation
struct User: Codable {
    let id: String
    let accounts: [Account]
    
    enum CodingKeys: String, CodingKey{
        case id = "user_id" // userId if .convertFromSnakeCase
        case accounts = "acounts"
    }
}


