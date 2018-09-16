//
//  EditListViewController.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/9/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit
import CryptoMarketDataKit

class EditListViewController: CryptoMarketViewController {
    
    // MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    weak var delegate: RefreshDelegate?
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.isEditing = true
        view.contentInset.bottom = 0
        return view
    }()
    
    let reuseIdentifier = "cellId"
    
    var symbol: String?
    var name: String?
    var count: Int!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
        
        loadDataFromUserDefaults()
        
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDataFromUserDefaults()
        tableView.reloadData()
    }
}

// MARK: - UI
private extension EditListViewController {
    func updateView() {
        setupNavBar()
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func setupNavBar() {
        
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneHandler(_:)))
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHandler(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        navigationItem.title = "Cryptocurrencies"
        
        var toolbarItems = [UIBarButtonItem]()
        toolbarItems.append(addButtonItem)
        toolbarItems.append(flexibleSpace)
        toolbarItems.append(doneButtonItem)
        
        self.setToolbarItems([addButtonItem, flexibleSpace, doneButtonItem], animated: true)
        self.navigationController?.isToolbarHidden = false
    }
}

// MARK: - Actions
private extension EditListViewController {
    @objc func doneHandler(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Refresh.tableView.rawValue), object: nil)
        self.dismiss(animated: true)
    }
    
    @objc func addHandler(_ sender: UIBarButtonItem) {
        let addViewController = AddViewController()
        let navViewController = UINavigationController(rootViewController: addViewController)
        present(navViewController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension EditListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowCount = self.cryptoMarketData?.count else { return 0 }
        return rowCount
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
}

// MARK: - UITableViewDelegate
extension EditListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
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
    }
}
