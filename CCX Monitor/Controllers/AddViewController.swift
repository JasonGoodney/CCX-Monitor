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
    
    // MARK: - ViewLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
        setupNavBar()
        
        // Used by loadAllData() to filter out user saved cryptocurrencies
        loadDataFromUserDefaults()
        
        loadAllData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        DispatchQueue.main.async { [unowned self] in
            self.navigationItem.searchController?.searchBar.becomeFirstResponder()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchController.isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Networking
    
    fileprivate func loadAllData() {
        getAllCryptocurrencyData { (error) in
            if error != nil {
                print("Error getting all data")
            } else {
                DispatchQueue.main.async {
                    
                    if error == nil {
                        
                        guard let cryptoMarketData = self.cryptoMarketData else { return }
                        
                        self.allData = self.allCryptocurrencyData?
                            .filter { !cryptoMarketData.contains($0) }
                        // slows doing view load
                        //.sorted(by: { $0.rank.toDouble()! < $1.rank.toDouble()! })
                        
                        
                    }
                }
            }
        }
    }
    
    // MARK: - UI
    
    fileprivate func setupTableView() {
        self.view.addSubview(tableView)
        tableView.frame = self.view.frame
    }
    
    fileprivate func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
    }
    
    fileprivate func setupNavBar() {
        
        titleLabel.text = "Type the cryptocurrencies name or symbol"
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.darkerLightGray
        navigationItem.titleView = titleLabel
    
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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

// MARK: - UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating

extension AddViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let dataItem = filteredData[indexPath.row]
        
        print(dataItem.name)
        
        self.cryptoMarketData?.append(dataItem)
        
        guard let data = self.cryptoMarketData else { return }
        CryptoMarketService.shared.saveArray(data, forKey: DataManager.defaultsKey)
        
        self.searchController.isActive = false
        self.dismiss(animated: true) {
            print("controller dismissing")
        }
    }
}
