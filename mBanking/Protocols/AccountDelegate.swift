//
//  AccountDelegate.swift
//  mBanking
//
//  Created by Borna Ungar on 13.01.2022..
//

import Foundation
protocol AccountDelegate: AnyObject {
    func switchAccount(_ account: Account)
}
