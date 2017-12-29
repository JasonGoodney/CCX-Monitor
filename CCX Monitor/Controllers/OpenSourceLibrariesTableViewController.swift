//
//  OpenSourceLibrariesTableViewController.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/27/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit

class OpenSourceLibrariesViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Acknowledgements"
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension OpenSourceLibrariesViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return acknowledgementNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return acknowledgementNames[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        cell.textLabel?.sizeToFit()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = acknowledgementLicenes[indexPath.section]

        return cell
    }
}


