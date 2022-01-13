//
//  OverviewViewModel.swift
//  mBanking
//
//  Created by Borna Ungar on 12.01.2022..
//

import Foundation
import RxCocoa
import RxSwift
protocol OverviewViewModel: AnyObject {
    
    var loaderSubject: ReplaySubject<Bool> {get}
    var loadUserDataSubject: ReplaySubject<()> {get set}
    var currentAccountTransactionsRelay: BehaviorRelay<[Transaction]> {get set}
    var currentAccountSubject: ReplaySubject<Account> {get set}
    
    var userAccounts: [Account] {get set}
    var userName: String {get set}
    var accountIBAN: String? {get set}
    var accountAmount: String? {get set}
    var accountCurrency: String? {get set}
    var accountName: String? {get set}
    
    func initializeViewModelObservables() -> [Disposable]
    
}

class OverviewViewModelImpl: OverviewViewModel {
        
    var currentAccountTransactionsRelay = BehaviorRelay<[Transaction]>.init(value: [])
    var loaderSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var loadUserDataSubject = ReplaySubject<()>.create(bufferSize: 1)
    var currentAccountSubject = ReplaySubject<Account>.create(bufferSize: 1)

    var userName = UserDefaults.standard.string(forKey: "userName") ?? ""
    var accountIBAN: String?
    var accountAmount: String?
    var accountCurrency: String?
    var accountName: String?
    var userAccounts: [Account] = []
    
    private let userRepository: UserRepository
    
    init(repository: UserRepository){
        self.userRepository = repository
    }
    
    func initializeViewModelObservables() -> [Disposable] {
        var disposables: [Disposable] = []
        disposables.append(initializeUserSubject(subject: loadUserDataSubject))
        disposables.append(setCurrentAccountSubject(subject: currentAccountSubject))
        return disposables
    }
    
    func initializeUserSubject(subject: ReplaySubject<()>) -> Disposable {
        return subject
            .flatMap{ [unowned self] (_) -> Observable<UserResponse> in
                self.loaderSubject.onNext(true)
                return self.userRepository.getAccounts()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { (userResponse) in
                let accounts = userResponse.accounts
                self.userAccounts = accounts
                self.currentAccountSubject.onNext(accounts[0])
                self.loaderSubject.onNext(false)
            })
    }
    
    func setCurrentAccountSubject(subject: ReplaySubject<Account>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { nextAccount in
                self.loaderSubject.onNext(true)
                self.accountName = "Account #\(nextAccount.id)"
                self.accountAmount = nextAccount.amount
                self.accountCurrency = nextAccount.currency
                self.accountIBAN = nextAccount.iban
                self.currentAccountTransactionsRelay.accept(nextAccount.transactions)
                self.loaderSubject.onNext(false)
            })
    }

}
