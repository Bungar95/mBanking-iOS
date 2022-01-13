//
//  PinDialogViewController.swift
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
    
    func initializeViewModelObservables() -> [Disposable]
}

class PinDialogViewModelImpl: PinDialogViewModel {
    var userRegistered: Bool
    var userPinSubject = ReplaySubject<String>.create(bufferSize: 1)
    
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
            .subscribe(onNext: { pin in
                
                if(self.userRegistered){
                    //checkLoginCredentails()
                }else{
                    UserDefaults.standard.setValue(pin, forKey: "pinCode")
                }
            })
    }
    
}
