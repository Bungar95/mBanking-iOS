//
//  Transaction.swift
//  mBanking
//
//  Created by Borna Ungar on 12.01.2022..
//

import Foundation
struct Transaction: Codable {
    let id: String
    let date: String
    let description: String
    let amount: String
    let type: String?
}
