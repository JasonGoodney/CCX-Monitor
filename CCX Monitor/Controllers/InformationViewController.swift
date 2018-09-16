//
//  InformationViewController.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/20/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit
import Eureka
import SafariServices

class InformationViewController: FormViewController {
    
    // MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var isBannerViewRemoved = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        
        isBannerViewRemoved = UserDefaults.standard.bool(forKey: "bannerViewState")
    
    }
    
}

// MARK: - UI
private extension InformationViewController {
    func updateView() {
        setupNavBar()
        setupForm()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneHandler(_:)))
        
        navigationItem.rightBarButtonItem = doneButtonItem
    }
    
    func setupForm() {
        form
            +++ Section("Data powered by")
            <<< LabelRow() { row in
                row.title = "Coin Market Cap"
                
                
                }.onCellSelection({ (cell, row) in
                    self.openSafari(row)
                })
            
            +++ Section("Open Source Libraries")
            
            <<< LabelRow() { row in
                row.title = "Show Acknowledgements"
                
                
                }.onCellSelection({ (cell, row) in
                    
                    self.showLibrariesUsed(row)
                })
            +++ Section("App Icon Background from")
            
            <<< LabelRow() { row in
                row.title = "mallibone.com"
                
                
                }.onCellSelection({ (cell, row) in
                    
                    self.openSafari(with: "https://mallibone.com/post/see-how-to-run-xamarin-test-cloud-runs-from-the-command-line", row)
                })
    }
}

// MARK: - Actions
private extension InformationViewController {
    @objc func doneHandler(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc func openSafari(with address: String = "https://coinmarketcap.com", _ sender: Any) {
        if let url = URL(string: address) {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
    
    @objc func showLibrariesUsed(_ sender: Any) {
        let openSourceLibrariesViewController = OpenSourceLibrariesViewController()
        navigationController?.pushViewController(openSourceLibrariesViewController, animated: true)
    }
}
