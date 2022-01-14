//
//  LoginViewModel.swift
//  mBanking
//
//  Created by Borna Ungar on 11.01.2022..
//

import Foundation
import RxSwift
import RxCocoa
protocol LoginViewModel: AnyObject {
    var userRegistered: Bool {get set}
    var userInfoSubject: ReplaySubject<(String, String)> {get set}
    var nameVerificationSubject: ReplaySubject<Bool> {get set}
    var successLoginSubject: ReplaySubject<()> {get set}
    
    var currentSessionName: String {get set}
    var currentSessionSurname: String {get set}
    var userName: String {get}
    var userSurname: String {get}
    
    func initializeViewModelObservables() -> [Disposable]
    func checkUserRegistered()
}

class LoginViewModelImpl: LoginViewModel {
    var userRegistered = false
    var userInfoSubject = ReplaySubject<(String, String)>.create(bufferSize: 1)
    var nameVerificationSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var successLoginSubject = ReplaySubject<()>.create(bufferSize: 1)
    
    var currentSessionName = ""
    var currentSessionSurname = ""
    var userName = ""
    var userSurname = ""
    
    func initializeViewModelObservables() -> [Disposable] {
        var disposables: [Disposable] = []
        disposables.append(storeUserSubject(subject: userInfoSubject))
        return disposables
    }
    
    func checkUserRegistered(){
        self.userRegistered = UserDefaults.standard.bool(forKey: "userRegistered")
        self.userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        self.userSurname = UserDefaults.standard.string(forKey: "userSurname") ?? ""
    }
}

private extension LoginViewModelImpl {
    
    func storeUserSubject(subject: ReplaySubject<(String, String)>) -> Disposable{
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { (name, surname) in
                UserDefaults.standard.setValue(name, forKey: "userName")
                UserDefaults.standard.setValue(surname, forKey: "userSurname")
                self.nameVerificationSubject.onNext(true)
            })
    }
}
