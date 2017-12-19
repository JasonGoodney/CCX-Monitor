//
//  DataManager.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/6/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import Foundation

public struct DataManager {
    
    enum BackendError: Error {
        case urlError(reason: String)
        case objectSerialization(reason: String)
    }
    
    static let defaultsKey = "tickers"
   

    public static let coinMarketCapApi = "https://api.coinmarketcap.com/v1/ticker/?limit=10"
    public static let baseCoinMarketCapApi = "https://api.coinmarketcap.com/v1/ticker/"
    
    public static func getJSONFromURL(_ resource: String,
                                      completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let url = Bundle.main.url(forResource: resource, withExtension: "json") {
                do {
                    //let url = URL(fileURLWithPath: filePath)
                    let data = try! Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                    completion(data, nil)
                }
            }
        }
    }
    
    
    public static func loadJSONForGlobalTicker(completionHandler: @escaping (GlobalMarketTicker?, Error?) -> Void){
        
        let endpoint = GlobalMarketTicker.endpoint()
        
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let tickers = try decoder.decode(GlobalMarketTicker.self, from: responseData)
                completionHandler(tickers, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
}