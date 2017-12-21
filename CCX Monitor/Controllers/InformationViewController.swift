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
                <<< SwitchRow("switchRowTag") { row in
                    row.title = "Show labraries used"
                }
                <<< LabelRow(){
                    
                    $0.hidden = Condition.function(["switchRowTag"], { form in
                        return !((form.rowBy(tag: "switchRowTag") as? SwitchRow)?.value ?? false)
                    })
                    $0.title = "Switch is on!"
                    
                }
        
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

}
