//
//  Account.swift
//  mBanking
//
//  Created by Borna Ungar on 12.01.2022..
//

import Foundation
struct Account: Codable {
    let id: String
    let iban: String
    let amount: String
    let currency: String
    let transactions: [Transaction]
    
    enum CodingKeys: String, CodingKey{
        case id, amount, currency, transactions
        case iban = "IBAN"
    }
}
