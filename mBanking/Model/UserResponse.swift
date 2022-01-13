//
//  UserResponse.swift
//  mBanking
//
//  Created by Borna Ungar on 12.01.2022..
//

import Foundation
struct UserResponse: Codable {
    let id: String
    let accounts: [Account]
    
    enum CodingKeys: String, CodingKey{
        case id = "userId" // user_id if without .convertFromSnakeCase
        case accounts = "acounts"
    }
}


