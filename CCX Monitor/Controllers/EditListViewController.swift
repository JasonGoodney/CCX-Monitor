//
//  EditListViewController.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/9/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit
import CryptoMarketDataKit
import GoogleMobileAds

class EditListViewController: CryptoMarketViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    weak var delegate: RefreshDelegate?
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.isEditing = true
        return view
    }()
    
    let reuseIdentifier = "cellId"
    
    var symbol: String?
    var name: String?
    var count: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if appDelegate.bannerViewState == .present {
            appDelegate.bannerView.rootViewController = self
            appDelegate.bannerView.load(GADRequest())
        }
        
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        setupNavBar()
        
        loadDataFromUserDefaults()
        
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDataFromUserDefaults()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneHandler(_:)))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHandler(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        navigationItem.title = "Cryptocurrencies"
        
        var toolbarItems = [UIBarButtonItem]()
        toolbarItems.append(addButton)
        toolbarItems.append(flexibleSpace)
        toolbarItems.append(doneButton)
        
        self.setToolbarItems([addButton, flexibleSpace, doneButton], animated: true)
        self.navigationController?.isToolbarHidden = false
        
    }

    @objc func doneHandler(_ sender: UIBarButtonItem) {
        self.delegate?.refreshTableView()
        self.dismiss(animated: true)
    }
    
    @objc func addHandler(_ sender: UIBarButtonItem) {
        let addViewController = AddViewController()
        let navViewController = UINavigationController(rootViewController: addViewController)
        present(navViewController, animated: true, completion: nil)
    }

}

extension EditListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowCount = self.cryptoMarketData?.count else { return 0 }
        return rowCount
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return appDelegate.bannerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch appDelegate.bannerViewState {
        case .present:
            return appDelegate.bannerView.frame.height
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        }

        symbol = self.cryptoMarketData![indexPath.row].symbol
        name = self.cryptoMarketData![indexPath.row].name
        cell?.textLabel?.text = symbol
        cell?.detailTextLabel?.text = name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            self.cryptoMarketData?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        guard let data = self.cryptoMarketData else { return }
        CryptoMarketService.shared.saveArray(data, forKey: DataManager.defaultsKey)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard var data = self.self.cryptoMarketData else { return }
        let movedObject = data[sourceIndexPath.row]
        
        data.remove(at: sourceIndexPath.row)
        data.insert(movedObject, at: destinationIndexPath.row)

        
        self.cryptoMarketData = data
        
        CryptoMarketService.shared.saveArray(data, forKey: DataManager.defaultsKey)
        print( self.cryptoMarketData?.map { $0.name } ?? "" )
    }
}

