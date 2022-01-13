//
//  NetworkManager.swift
//  mBanking
//
//  Created by Borna Ungar on 12.01.2022..
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire
class NetworkManager{
    
    func getData<T: Codable>(from url: String) -> Observable<T>{
        
        return Observable.create{ observer in
            let request = AF.request(url)
                .validate().responseDecodable(of: T.self, decoder: SerializationManager.jsonDecoder){ networkResponse in
                    switch networkResponse.result{
                    case .success:
                        do{
                            let response = try networkResponse.result.get()
                            observer.onNext(response)
                            observer.onCompleted()
                        }
                        catch(let error){
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
