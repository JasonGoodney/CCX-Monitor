//
//  AddViewController.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/11/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit
import CryptoMarketDataKit

class AddViewController: CryptoMarketViewController {
    
    // MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let reuseIdentifier = "cellId"

    let searchController = UISearchController(searchResultsController: nil)
    
    let titleLabel = UILabel()
    
    var allData: [CryptoMarketData]?
    
    var filteredData = [CryptoMarketData]()
    
    fileprivate lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.contentInset.bottom = 0
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        
        // Used by loadAllData() to filter out user saved cryptocurrencies
        loadDataFromUserDefaults()
        
        loadAllData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.searchController.isActive = true
            self.searchController.searchBar.becomeFirstResponder()
        }
        
        
    }
    
    // MARK: - Networking
    
    fileprivate func loadAllData() {
        getAllCryptocurrencyData { (error) in
            if let error = error {
                print("Error getting all data: \(error) \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                guard let cryptoMarketData = self.cryptoMarketData else { return }
                
                self.allData = self.allCryptocurrencyData?
                    .filter { !cryptoMarketData.contains($0) }
                // slows doing view load
                //.sorted(by: { $0.rank.toDouble()! < $1.rank.toDouble()! })

            }
        }
    }

    // MARK: - SearchBar
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Filtering
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        guard let allData = self.allData else { return }
        filteredData = allData.filter({( dataItem: CryptoMarketData ) -> Bool in
            return dataItem.name.lowercased().contains(searchText.lowercased()) ||      dataItem.symbol.lowercased().contains(searchText.lowercased())
        })

        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

// MARK: - UI
private extension AddViewController {
    func updateView() {
        setupNavBar()
        setupTableView()
        setupSearchController()
    }
    
    func setupTableView() {
        self.view.addSubview(tableView)
        tableView.frame = self.view.frame
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        searchController.delegate = self
    }
    
    func setupNavBar() {
        
        titleLabel.text = "Type the cryptocurrencies name or symbol"
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.darkerLightGray
        navigationItem.titleView = titleLabel
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating

extension AddViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }

    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in }) { (completed) -> Void in
            searchController.searchBar.becomeFirstResponder()
        }
    }
}

// MARK: - UITableViewDataSource

extension AddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredData.count
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        var dataItem: CryptoMarketData
        
        if isFiltering() {
            dataItem = filteredData[indexPath.row]
            cell?.textLabel?.text = dataItem.symbol
            cell?.detailTextLabel?.text = dataItem.name
        }

        return cell!
    }
    
}

// MARK: - UITableViewDelegate
extension AddViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dataItem = filteredData[indexPath.row]
        
        print(dataItem.name)
        
        self.cryptoMarketData?.append(dataItem)
        
        guard let data = self.cryptoMarketData else { return }
        CryptoMarketService.shared.saveArray(data, forKey: DataManager.defaultsKey)
        
        self.searchController.isActive = false
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Refresh.tableView.rawValue), object: nil)
        self.dismiss(animated: true) {
            
        }
    }
}
