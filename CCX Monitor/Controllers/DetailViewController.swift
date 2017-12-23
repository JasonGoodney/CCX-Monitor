//
//  DetailViewController.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/10/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit
import CryptoMarketDataKit
import GoogleMobileAds


class DetailViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var data: CryptoMarketData?

    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame)
        view.delegate = self
        view.dataSource = self
        view.separatorColor = .clear
        view.allowsSelection = false
        return view
    }()
    
    var keys = ["Rank", "Name", "Symbol", "Price", "Change (1h)", "Change (24h)", "Change (7d)", "Volume (24h)", "Market Cap", "Available Supply", "Total Supply", "Max Supply", "Last Updated"]
    
    var values: [String] = []
    
    let reuseIdentifier = "cellId"
    
    convenience init(data: CryptoMarketData) {
        self.init()
        self.data = data
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.bannerViewState == .present {
            appDelegate.bannerView.rootViewController = self
            appDelegate.bannerView.load(GADRequest())
        }
        

        view.addSubview(tableView)
        
    
        guard let data = self.data else { return }
        navigationItem.title = data.name

        values = loadValues(from: data)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if keys.count == values.count {
            return keys.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: appDelegate.bannerView.frame.height)
        headerView.addSubview(appDelegate.bannerView)
        return appDelegate.bannerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch appDelegate.bannerViewState {
        case .present:
            return appDelegate.bannerView.frame.height
        case .removed:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        }
        
        
        cell?.textLabel?.text = keys[indexPath.row]
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        cell?.detailTextLabel?.text = values[indexPath.row]
        
        return cell!
    }
}

extension DetailViewController {
    
    // Dafuq is this?
    // Makes sure an assignment in not nil and crash the app
    // Add a value of "nil" is it is
    // If it is nil, I dont want it to be user facing
    // So the value and the matching key index are removed
    // pieceacrap
    fileprivate func loadValues(from ticker: CryptoMarketData) -> [String] {
        let price: String = ticker.priceUsd.toDouble() != nil ?
            (String.formatCurrency(value: ticker.priceUsd.toDouble(), fractionDigits: 2) + " $") : "nil"
        
        let change1h: String = ticker.percentChange1h.toDouble() != nil ?
            (String.twoDigitsFormatted(ticker.percentChange1h.toDouble()!) + " %") : "nil"
        
        let change24h: String = ticker.percentChange24h.toDouble() != nil ?
            (String.twoDigitsFormatted(ticker.percentChange24h.toDouble()!) + " %") : "nil"
        
        let change7d: String = ticker.percentChange7d.toDouble() != nil ?
            (String.twoDigitsFormatted(ticker.percentChange7d.toDouble()!) + " %") : "nil"
        
        let volume24h: String = ticker.volumeUsd24h.toDouble() != nil ?
            (String.formatCurrency(value: ticker.volumeUsd24h.toDouble(), fractionDigits: 2) + " $") : "nil"
        
        let marketCap: String = ticker.marketCapUsd.toDouble() != nil ?
            (String.formatCurrency(value: ticker.marketCapUsd.toDouble(), fractionDigits: 2) + " $") : "nil"
        
        let availableSupply: String = ticker.availableSupply.toDouble() != nil ?
            (String.formatCurrency(value: ticker.availableSupply.toDouble(), fractionDigits: 0) + " " + ticker.symbol.uppercased()) : "nil"
        
        let totalSupply: String = ticker.totalSupply.toDouble() != nil ?
            (String.formatCurrency(value: ticker.totalSupply.toDouble(), fractionDigits: 0) + " " + ticker.symbol.uppercased()) : "nil"
        
        let maxSupply: String = ticker.maxSupply.toDouble() != nil ?
            (String.formatCurrency(value: ticker.maxSupply.toDouble(), fractionDigits: 0) + " " + ticker.symbol.uppercased()) : "nil"
        

        let date = Date(timeIntervalSince1970: TimeInterval.init(ticker.lastUpdated)!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        let lastUpdated = dateFormatter.string(from: date)
        
        var values = [
            ticker.rank,
            ticker.name,
            ticker.symbol,
            price,
            change1h,
            change24h,
            change7d,
            volume24h,
            marketCap,
            availableSupply,
            totalSupply,
            maxSupply,
            lastUpdated
        ]
        
        for i in 0..<values.count - 1  {
            if values[i] == "nil" {
                values.remove(at: i)
                keys.remove(at: i)
            }
        }
        
        return values
    }
}
