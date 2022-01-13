//
//  PinDialogViewModel.swift
//  mBanking
//
//  Created by Borna Ungar on 11.01.2022..
//

import Foundation
import RxSwift
import RxCocoa
protocol PinDialogViewModel: AnyObject {
    var userRegistered: Bool {get set}
    var userPinSubject: ReplaySubject<String> {get set}
    var pinVerificationSubject: ReplaySubject<Verification> {get set}
    var dismissSubject: ReplaySubject<()> {get set}
    
    func initializeViewModelObservables() -> [Disposable]
}

enum Verification {
    case login
    case register
    case failure
}

class PinDialogViewModelImpl: PinDialogViewModel {
    var userRegistered: Bool
    var userPinSubject = ReplaySubject<String>.create(bufferSize: 1)
    var pinVerificationSubject = ReplaySubject<Verification>.create(bufferSize: 1)
    var dismissSubject = ReplaySubject<()>.create(bufferSize: 1)

    var currentSessionPinCode = ""

    init(){
        self.userRegistered = UserDefaults.standard.bool(forKey: "userRegistered")
    }
    
    func initializeViewModelObservables() -> [Disposable] {
        var disposables: [Disposable] = []
        disposables.append(initializeUserPinSubject(subject: userPinSubject))
        return disposables
    }
    
}

private extension PinDialogViewModelImpl {
    
    func initializeUserPinSubject(subject: ReplaySubject<String>) -> Disposable{
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] pin in
                if(self.userRegistered){
                    self.currentSessionPinCode = pin
                    self.pinVerificationSubject.onNext(self.pinCodeVerification())
                }else{
                    UserDefaults.standard.setValue(pin, forKey: "pinCode")
                    UserDefaults.standard.setValue(true, forKey: "userRegistered")
                    self.userRegistered = true
                    self.pinVerificationSubject.onNext(.register)
                    
                }
            })
    }
    
    func pinCodeVerification() -> Verification{
        let userPinCode = UserDefaults.standard.string(forKey: "pinCode")
        return (userPinCode == currentSessionPinCode) ? .login : .failure
    }
    
}
