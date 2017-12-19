//
//  GlobalData.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/8/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import Foundation

protocol EndpointProtocol {
    static func endpoint() -> String
}

public struct GlobalMarketTicker  {
    let totalMarketCapUsd: Double
    let total24hVolumeUsd: Double
    let activeCurrencies: Int
    let activeAssets: Int
    let activeMarkets: Int
    let bitcoinPercentageOfMarketCap: Double
    
    enum CodingsKeys: String, CodingKey  {
        case totalMarketCapUsd = "total_market_cap_usd"
        case total24hVolumeUsd = "total_24h_volume_usd"
        case activeCurrencies = "active_currencies"
        case activeAssets = "active_assets"
        case activeMarkets = "active_markets"
        case bitcoinPercentageOfMarketCap = "bitcoin_percentage_of_market_cap"
    }
    
}

extension GlobalMarketTicker: EndpointProtocol {
    static func endpoint() -> String {
        return "https://api.coinmarketcap.com/v1/global/?convert=usd&limit=0"
    }
}

extension GlobalMarketTicker: Encodable {
    public func encode(to encoder: Encoder) throws {
        
    }
}

extension GlobalMarketTicker: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingsKeys.self)
        totalMarketCapUsd = try container.decode(Double.self, forKey: .totalMarketCapUsd)
        total24hVolumeUsd = try container.decode(Double.self, forKey: .total24hVolumeUsd)
        activeCurrencies = try container.decode(Int.self, forKey: .activeCurrencies)
        activeAssets = try container.decode(Int.self, forKey: .activeAssets)
        activeMarkets = try container.decode(Int.self, forKey: .activeMarkets)
        bitcoinPercentageOfMarketCap = try container.decode(Double.self, forKey: .bitcoinPercentageOfMarketCap)
    }
}
