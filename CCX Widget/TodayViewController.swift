//
//  TodayViewController.swift
//  CCX Widget
//
//  Created by Jason Goodney on 12/11/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit
import NotificationCenter
import CryptoMarketDataKit

class TodayViewController: CryptoMarketViewController, NCWidgetProviding {
    
    let baseCoinMarketCapApi = "https://api.coinmarketcap.com/v1/ticker/"
    let defaultsKey = "tickers"
    var widgetData = [CryptoMarketData]()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(TodayWidgetTableViewCell.self, forCellReuseIdentifier: TodayWidgetTableViewCell.reuseIdentifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        self.loadDataFromUserDefaults()
        refreshUserDefaultsData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshUserDefaultsData() {
//        guard let data = self.cryptoMarketData else { return }
//        for i in 0..<2 {
//            getSingleCryptocurrencyData(at: baseCoinMarketCapApi + data[i].id, completion: { (error) in
//                if error == nil {
//                    guard let data = self.singleCryptocurrencyData else { return }
//                    self.cryptoMarketData![i] = data
//                }
//            })
//        }
//        CryptoMarketService.shared.saveArray(data, forKey: defaultsKey)
        
        loadDataFromUserDefaults()
        widgetData = self.cryptoMarketData!
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        getWeatherData(latLong, completion: { (error) -> () in
//            if error == nil {
//                self.updateData()
//                completionHandler(.NewData)
//            } else {
//                completionHandler(.NoData)
//            }
//        })
        
        refreshUserDefaultsData()
        completionHandler(NCUpdateResult.newData)
   }
//
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsets.zero
    }
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowCount = self.cryptoMarketData?.count else { return 0 }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayWidgetTableViewCell.reuseIdentifier, for: indexPath) as! TodayWidgetTableViewCell
        
       // if let data = self.cryptoMarketData {
            let item = widgetData[indexPath.row]
            cell.configureWithCell(item)
        //}
        
        return cell
    }
    
    
}

