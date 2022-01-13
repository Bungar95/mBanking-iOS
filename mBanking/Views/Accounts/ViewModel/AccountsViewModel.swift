//
//  AccountsViewModel.swift
//  mBanking
//
//  Created by Borna Ungar on 13.01.2022..
//

import Foundation
import RxSwift
import RxCocoa
protocol AccountsViewModel: AnyObject {
    var accounts: [Account] {get set}
    var accountsRelay: BehaviorRelay<[Account]> {get set}
    var dismissSubject: ReplaySubject<()> {get set}
    var loaderSubject: ReplaySubject<Bool> {get set}
}

class AccountsViewModelImpl: AccountsViewModel {
    var accounts: [Account]
    var accountsRelay = BehaviorRelay<[Account]>.init(value: [])
    var dismissSubject = ReplaySubject<()>.create(bufferSize: 1)
    var loaderSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    
    init(accounts: [Account]){
        self.accounts = accounts
    }
}
