//
//  CryptoMarketService.swift
//  CryptoMarketDataKit
//
//  Created by Jason Goodney on 12/12/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import Foundation

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}

open class CryptoMarketService {
    
    enum MarketDataType {
        case cryptoMarket
        case globalMarket
    }
    
    public struct DataManager {
        public static let defaultsKey = "tickers"
        public static let coinMarketCapApiAll = "https://api.coinmarketcap.com/v1/ticker/?limit=0"
    }
    
    typealias CryptoMarketCompletionBlock = (_ data: [CryptoMarketData]?, _ error: Error?) -> ()
    
    let session: URLSession
    
    open class var shared: CryptoMarketService {
        struct Singleton {
            static let instance = CryptoMarketService()
        }
        return Singleton.instance
    }
    
    init() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    func fetchJsonData(at endpoint: String, dataType: MarketDataType, completion: @escaping CryptoMarketCompletionBlock) {
        
        guard let url = URL(string: endpoint) else {
            print("Error: can not create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completion(nil, error)
            return
        }
        
       
        
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completion(nil, error)
                return
            }
            
            guard error == nil else {
                print("dataTask error == nil")
                completion(nil, error)
                return
            }
            
            let decorder = JSONDecoder()
            
            do {
                switch dataType {
                case .cryptoMarket:
                    let data = try decorder.decode([CryptoMarketData].self, from: responseData)
                    completion(data, nil)
                case .globalMarket:
                    break
                }
                
            } catch {
                let error = BackendError.objectSerialization(reason: "error serializing dictionary")
                print(error)
                completion(nil, error)
            }
        }
        
        task.resume()
        
    }
    
    public func saveArray<T: Encodable>(_ array: [T], forKey name: String) {
        
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(array) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: name)
            
        } else {
            print("Failed to save.")
        }
    }
    
    public func loadArray<T: Decodable>(forKey name: String) throws -> [T] {
        let defaults = UserDefaults.standard
        var array = [T]()
        
        if let savedData = defaults.object(forKey: name) as? Data {
            let jsonDecoded = JSONDecoder()
            do {
                array = try jsonDecoded.decode([T].self, from: savedData)
            } catch {
                print("Failed to load")
            }
        }
        
        return array
    }
}
