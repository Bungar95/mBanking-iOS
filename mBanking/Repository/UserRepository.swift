//
//  UserRepository.swift
//  mBanking
//
//  Created by Borna Ungar on 12.01.2022..
//

import Foundation
import RxSwift
protocol UserRepository: AnyObject {
    func getAccounts() -> Observable<UserResponse>
}

class UserRepositoryImpl: UserRepository {
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getAccounts() -> Observable<UserResponse> {
        let url = "https://mportal.asseco-see.hr/builds/ISBD_public/Zadatak_1.json"
        let userResponseObservable: Observable<UserResponse> = networkManager.getData(from: url)
        return userResponseObservable
    }
}
