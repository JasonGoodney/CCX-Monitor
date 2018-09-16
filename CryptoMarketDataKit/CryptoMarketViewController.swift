//
//  CryptoMarketViewController.swift
//  CryptoMarketDataKit
//
//  Created by Jason Goodney on 12/12/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit

open class CryptoMarketViewController: UIViewController {
    
    public var cryptoMarketData: [CryptoMarketData]?
    public var allCryptocurrencyData: [CryptoMarketData]?
    public var singleCryptocurrencyData: CryptoMarketData?
    
    public func getSingleCryptocurrencyData(at endpoint: String, completion: @escaping (_ error: Error?) -> Void) {
        
        CryptoMarketService.shared.fetchJsonData(at: endpoint, dataType: .cryptoMarket) { (data, error) -> () in
            
            DispatchQueue.main.async {
                
                self.singleCryptocurrencyData = data?[0]
                
                completion(error)
            }
        }
        if endpoint == "https://api.coinmarketcap.com/v1/ticker/bitcoin/" {
            print("cryptomarketVC", self.singleCryptocurrencyData?.priceUsd ?? "")
        }
        
    }
    
    public func getAllCryptocurrencyData(completion: @escaping (_ error: Error?) -> Void) {
        let endpoint = CryptoMarketService.DataManager.coinMarketCapApiAll
        CryptoMarketService.shared.fetchJsonData(at: endpoint, dataType: .cryptoMarket) { (data, error) -> () in
            
            DispatchQueue.main.async {
                self.allCryptocurrencyData = data
                completion(error)
            }
            
        }
 
    }
    
    public func getCryptoMarketData(at endpoint: String, completion: @escaping (_ error: Error?) -> ()) {
        CryptoMarketService.shared.fetchJsonData(at: endpoint, dataType: .cryptoMarket) { (data, error) -> () in

            DispatchQueue.main.async {
                self.cryptoMarketData = data
                completion(error)
            }
            
        }
    }
    
    public func loadDataFromUserDefaults(completion: (() -> Void)? = nil) {
        do {
            self.cryptoMarketData = try CryptoMarketService.shared.loadArray(forKey: CryptoMarketService.DataManager.defaultsKey)
           
        } catch {
            print("defaults are nil")
        }
    }
}
