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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var isBannerViewRemoved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        isBannerViewRemoved = UserDefaults.standard.bool(forKey: "bannerViewState")
        
        print("viewdidload")
        form
            +++ Section("Data powered by")
                <<< LabelRow() { row in
                    row.title = "Coin Market Cap"
                    
                    
                }.onCellSelection({ (cell, row) in
                    self.openSafari(row)
                })
            
            +++ Section("For current session")
                <<< SwitchRow() { row in
                    row.title = "Remove ads"
                    row.value = isBannerViewRemoved
                    }.onChange({ (row) in
                        if row.value == true {
                            self.appDelegate.bannerViewState = .removed
                            self.isBannerViewRemoved = true
                            UserDefaults.standard.set(self.isBannerViewRemoved, forKey: "bannerViewState")
                        } else {
                            self.appDelegate.bannerViewState = .present
                            self.isBannerViewRemoved = false
                        }
                        row.updateCell()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneHandler(_:)))
        
        navigationItem.rightBarButtonItem = doneButtonItem
    }
    
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
