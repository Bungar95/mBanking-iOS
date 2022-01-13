//
//  SerializationManager.swift
//  mBanking
//
//  Created by Borna Ungar on 12.01.2022..
//

import Foundation
class SerializationManager {
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .deferredToData
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    public func parse<T: Codable>(jsonData: Data) -> T?{
        let object: T?
        do {
            object = try SerializationManager.jsonDecoder.decode(T.self, from: jsonData)
            
        } catch {
            print("decode error")
            object = nil
        }
        return object
    }
}
