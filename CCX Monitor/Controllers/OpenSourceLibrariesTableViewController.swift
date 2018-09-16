//
//  OpenSourceLibrariesTableViewController.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/27/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit

class OpenSourceLibrariesViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseIdentifier)
        return view
    }()
    
    let reuseIdentifier = "cellId"
    let acknowledgementNames = [
        Acknowledgements.Name.snapKit.rawValue,
        Acknowledgements.Name.euerka.rawValue,
        Acknowledgements.Name.eFAutoScrollLabel.rawValue
    ]
    
    let acknowledgementLicenes = [
        Acknowledgements.License.snapKit.rawValue,
        Acknowledgements.License.eureka.rawValue,
        Acknowledgements.License.eFAutoScrollLabel.rawValue
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Acknowledgements"
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
    }
    
}

// MARK: - UITableViewDataSource
extension OpenSourceLibrariesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return acknowledgementNames.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.textLabel?.sizeToFit()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = acknowledgementLicenes[indexPath.section]

        return cell
    }
}

// MARK: - UITableViewDelegate
extension OpenSourceLibrariesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return acknowledgementNames[section]
    }
}

