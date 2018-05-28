//
//  CryptoMarketData.swift
//  CryptoMarketDataKit
//
//  Created by Jason Goodney on 12/12/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import Foundation

public struct CryptoMarketData: Equatable {
    
    public private(set) var id: String
    public private(set) var name: String
    public private(set) var symbol: String
    public private(set) var rank: String
    public private(set) var priceUsd: String
    public private(set) var priceBtc: String
    public private(set) var volumeUsd24h: String
    public private(set) var marketCapUsd: String
    public private(set) var availableSupply: String
    public private(set) var totalSupply: String
    public private(set) var maxSupply: String
    public private(set) var percentChange1h: String
    public private(set) var percentChange24h: String
    public private(set) var percentChange7d: String
    public private(set) var lastUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case rank
        case priceUsd = "price_usd"
        case priceBtc = "price_btc"
        case volumeUsd24h = "24h_volume_usd"
        case marketCapUsd = "market_cap_usd"
        case availableSupply = "available_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case percentChange1h = "percent_change_1h"
        case percentChange24h = "percent_change_24h"
        case percentChange7d = "percent_change_7d"
        case lastUpdated = "last_updated"
    }
    
    public init(cryptoMarketDictionary: [String: String]) {
        id = cryptoMarketDictionary["id"]!
        name = cryptoMarketDictionary["name"]!
        symbol = cryptoMarketDictionary["symbol"]!
        rank = cryptoMarketDictionary["rank"]!
        priceUsd = cryptoMarketDictionary["priceUsd"]!
        priceBtc = cryptoMarketDictionary["priceBtc"]!
        volumeUsd24h = cryptoMarketDictionary["volumeUsd24h"]!
        marketCapUsd = cryptoMarketDictionary["marketCapUsd"]!
        availableSupply = cryptoMarketDictionary["availableSupply"]!
        totalSupply = cryptoMarketDictionary["totalSupply"]!
        maxSupply = cryptoMarketDictionary["maxSupply"]!
        percentChange1h = cryptoMarketDictionary["percentChange1h"]!
        percentChange24h = cryptoMarketDictionary["percentChange24h"]!
        percentChange7d = cryptoMarketDictionary["percentChange7d"]!
        lastUpdated = cryptoMarketDictionary["lastUpdated"]!
        
 
    }
    
    public static func ==(lhs: CryptoMarketData, rhs: CryptoMarketData) -> Bool {
        return lhs.name == rhs.name
    }
}

extension CryptoMarketData: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(rank, forKey: .rank)
        try container.encode(priceUsd, forKey: .priceUsd)
        try container.encode(priceBtc, forKey: .priceBtc)
        try container.encode(volumeUsd24h, forKey: .volumeUsd24h)
        try container.encode(marketCapUsd, forKey: .marketCapUsd)
        try container.encode(availableSupply, forKey: .availableSupply)
        try container.encode(totalSupply, forKey: .totalSupply)
        try container.encode(maxSupply, forKey: .maxSupply)
        try container.encode(percentChange1h, forKey: .percentChange1h)
        try container.encode(percentChange24h, forKey: .percentChange24h)
        try container.encode(percentChange7d, forKey: .percentChange7d)
        try container.encode(lastUpdated, forKey: .lastUpdated)
    }
    
}

extension CryptoMarketData: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        symbol = try values.decode(String.self, forKey: .symbol)
        rank = try values.decode(String.self, forKey: .rank)
        priceUsd = try values.decodeIfPresent(String.self, forKey: .priceUsd) ?? ""
        priceBtc = try values.decodeIfPresent(String.self, forKey: .priceBtc) ?? ""
        volumeUsd24h = try values.decodeIfPresent(String.self, forKey: .volumeUsd24h) ?? ""
        marketCapUsd = try values.decodeIfPresent(String.self, forKey: .marketCapUsd) ?? ""
        availableSupply = try values.decodeIfPresent(String.self, forKey: .availableSupply) ?? ""
        totalSupply = try values.decodeIfPresent(String.self, forKey: .totalSupply) ?? ""
        maxSupply = try values.decodeIfPresent(String.self, forKey: .maxSupply) ?? ""
        percentChange1h = try values.decodeIfPresent(String.self, forKey: .percentChange1h) ?? ""
        percentChange24h = try values.decodeIfPresent(String.self, forKey: .percentChange24h) ?? ""
        percentChange7d = try values.decodeIfPresent(String.self, forKey: .percentChange7d) ?? ""
        lastUpdated = try values.decodeIfPresent(String.self, forKey: .lastUpdated) ?? ""
    }
}
