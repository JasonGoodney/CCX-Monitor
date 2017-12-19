//
//  Ticker.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/5/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import Foundation

public struct Ticker {
    
    let id: String
    let name: String
    let symbol: String
    let rank: String
    let priceUsd: String
    let priceBtc: String
    let volumeUsd24h: String
    let marketCapUsd: String
    let availableSupply: String
    let totalSupply: String
    let maxSupply: String
    let percentChange1h: String
    let percentChange24h: String
    let percentChange7d: String
    let lastUpdated: String
    
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
    
}

extension Ticker: ArchivableStruct {
    
    public var dataDictionary: [String : AnyObject] {
        get {
            return [
                "id"              : self.id as AnyObject,
                "name"            : self.name as AnyObject,
                "symbol"          : self.symbol as AnyObject,
                "rank"            : self.rank as AnyObject,
                "priceUsd"        : self.priceUsd as AnyObject,
                "priceBtc"        : self.priceBtc as AnyObject,
                "volume24h"       : self.volumeUsd24h as AnyObject,
                "marketCapUsd"    : self.marketCapUsd as AnyObject,
                "availableSupply" : self.availableSupply as AnyObject,
                "totalSupply"     : self.totalSupply as AnyObject,
                "maxSupply"       : self.maxSupply as AnyObject,
                "percentChange1h" : self.percentChange1h as AnyObject,
                "percentChange24h": self.percentChange24h as AnyObject,
                "percentChange7d" : self.percentChange7d as AnyObject,
                "lastUpdated"     : self.lastUpdated as AnyObject
            ]
        }
    }
    
    public init(dataDictionary aDict: [String : AnyObject]) {
        self.id = aDict["id"] as! String
        self.name = aDict["name"] as! String
        self.symbol = aDict["symbol"] as! String
        self.rank = aDict["rank"] as! String
        self.priceUsd = aDict["priceUsd"] as! String
        self.priceBtc = aDict["priceBtc"] as! String
        self.volumeUsd24h = aDict["volumeUsd24h"] as! String
        self.marketCapUsd = aDict["marketCapUsd"] as! String
        self.availableSupply = aDict["availableSupply"] as! String
        self.totalSupply = aDict["totalSupply"] as! String
        self.maxSupply = aDict["maxSupply"] as! String
        self.percentChange1h = aDict["percentChange1h"] as! String
        self.percentChange24h = aDict["percentChange24h"] as! String
        self.percentChange7d = aDict["percentChange7d"] as! String
        self.lastUpdated = aDict["lastUpdated"] as! String
    }
    
    
}


extension Ticker: EndpointProtocol {
    public static func endpoint() -> String {
        return "https://api.coinmarketcap.com/v1/ticker/?convert=usd&limit=5"
    }
}

extension Ticker: Encodable {
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
    
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

extension Ticker: Decodable {
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

