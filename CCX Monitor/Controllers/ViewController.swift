//
//  ViewController.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/5/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices
import CryptoMarketDataKit
import GoogleMobileAds

protocol RefreshDelegate: class {
    func refreshTableView()
}

class ViewController: CryptoMarketViewController {
    
    fileprivate lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = 88
        view.register(TickerCell.self, forCellReuseIdentifier: TickerCell.reuseIdentifier())
        return view
    }()

    fileprivate var globalMarketView: GlobalMarketView = {
        let view = GlobalMarketView()
        view.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 44)
        return view
    }()
    
    let date = Date()
    let dateFormatter = DateFormatter()

    fileprivate let cellId = "Cell"
    fileprivate var globalMarketTicker: GlobalMarketTicker!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    weak var bannerViewStateDelegate: BannerViewStateDelegate?
    var isLaunch = true
    var notification: NSObjectProtocol?
    let loadingViewController = LoadingViewController()
    var timer  = Timer()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: OperationQueue.main) { (notification) in
            self.loadDataFromUserDefaults()
            
            self.refreshDataFromUserDefaults()
        }
        
        setupTableView()
        setupNavBar()
        setupForceTouch()
        
        updateGlobalTickerData {
            self.setupGlobalMarketView()
        }
        
        if (self.cryptoMarketData?.isEmpty == true) {
            getCryptoMarketData(at: DataManager.coinMarketCapApi) { (error) in
                if error == nil {
                    guard let data = self.cryptoMarketData else { return }
                    CryptoMarketService.shared.saveArray(data, forKey: CryptoMarketService.DataManager.defaultsKey)
                }
            }
        }
       
        tableView.reloadData()
        
        runDataRefreshTimer()
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if appDelegate.bannerViewState == .present {
            appDelegate.bannerView.rootViewController = self
            appDelegate.bannerView.load(GADRequest())
        }
       
        globalMarketView.autoScrollLabel.scrollLabelIfNeeded()
        
        
        if isLaunch == false {
            print("viewwillappear")
            loadDataFromUserDefaults()
            refreshDataFromUserDefaults()
            //self.tableView.reloadData()
            
            isLaunch = !isLaunch
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isLaunch == false {
            print("viewdidappear")
            loadDataFromUserDefaults()
            refreshDataFromUserDefaults()
            //self.tableView.reloadData()
            
            isLaunch = !isLaunch
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let data = self.cryptoMarketData else { return }
        CryptoMarketService.shared.saveArray(data, forKey: CryptoMarketService.DataManager.defaultsKey)
    }
    
    func runDataRefreshTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateDataForTableView), userInfo: nil, repeats: true)
    }
    
    func refreshDataFromUserDefaults() {
        guard var cryptoMarketData = self.cryptoMarketData else { return }
        let dispatchGroup = DispatchGroup()
        
        for i in 0..<cryptoMarketData.count {
            dispatchGroup.enter()
            getSingleCryptocurrencyData(at: DataManager.baseCoinMarketCapApi + cryptoMarketData[i].id, completion: { (error) in
                
                if error == nil {
                    guard let data = self.singleCryptocurrencyData else { return }
                    
//                    if data.id == "bitcoin" {
//                        print("VC", data.priceUsd)
//                    }
                    
                    cryptoMarketData[i] = data
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            self.cryptoMarketData = cryptoMarketData
//            print( self.cryptoMarketData?.map { $0.priceUsd } ?? "" )
            CryptoMarketService.shared.saveArray(self.cryptoMarketData!, forKey: CryptoMarketService.DataManager.defaultsKey)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    fileprivate func setupGlobalMarketView(){
        view.addSubview(globalMarketView)
        globalMarketView.backgroundColor = .white
        
        globalMarketView.delegate = self
        globalMarketView.snp.makeConstraints({ (make) in
            make.height.equalTo(44)
            
            if #available(iOS 11.0, *) {
                //Bottom guide
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
                //Leading guide
                make.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin)
                //Trailing guide
                make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin)
                
            } else {
                make.bottomMargin.equalToSuperview()
                make.width.equalToSuperview()
            }

        })
        
        
    }


    private func setupNavBar() {
        
        dateFormatter.dateFormat = "EEEE\nMMMM d"
        let dateLabel = FatGrayLabel()
        dateLabel.numberOfLines = 2
        dateLabel.text = dateFormatter.string(from: date)
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        let leftItem = UIBarButtonItem(customView: dateLabel)
        let rightItem = UIBarButtonItem(customView: infoButton)
        
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rightItem

        navigationItem.title =  "CCX Monitor"
        navigationController?.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            let height = globalMarketView.bounds.size.height
            make.bottom.equalToSuperview().inset(height)
        })
        
    }

    func setupForceTouch() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }

    @objc func updateDataForTableView() {
        refreshDataFromUserDefaults()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func removeBanner() {
        appDelegate.bannerViewState = .removed
        self.tableView.sectionHeaderHeight = 0.0
        self.tableView.reloadData()
    }
    
    func addBanner() {
        self.tableView.sectionHeaderHeight = appDelegate.bannerView.frame.height
        self.tableView.reloadData()
    }


    @objc func infoButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Data powered by", message: nil, preferredStyle: .actionSheet)
 
        let coinMarketCapAction = UIAlertAction(title: "CoinMarketCap.com", style: .default) { (action) in
            self.openSafari(action)
        }
        let removeAdsAction = UIAlertAction(title: "Remove ads for session", style: .default) { (action) in
            self.removeBanner()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(coinMarketCapAction)
        alertController.addAction(removeAdsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc func openSafari(with address: String = "https://coinmarketcap.com", _ sender: Any) {
        if let url = URL(string: address) {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }

    func updateGlobalTickerData(completion: @escaping () -> Void) {
        DataManager.loadJSONForGlobalTicker { (global, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let global = global else {
                print("error getting global data: result is nil")
                return
            }
            
            self.globalMarketTicker = global
            
            DispatchQueue.main.async {
                self.globalMarketView = GlobalMarketView(
                    self.globalMarketTicker.totalMarketCapUsd,
                    self.globalMarketTicker.total24hVolumeUsd,
                    self.globalMarketTicker.activeCurrencies,
                    self.globalMarketTicker.activeAssets,
                    self.globalMarketTicker.bitcoinPercentageOfMarketCap
                )
                
                completion()
            }
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
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
        //print(appDelegate.bannerViewState)
        switch appDelegate.bannerViewState {
        case .present:
            return appDelegate.bannerView.frame.height
        case .removed:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TickerCell.reuseIdentifier(), for: indexPath) as! TickerCell
        
        if let data = cryptoMarketData {
            let item = data[indexPath.row]
            cell.configureWithCell(item)
        }
       
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let data = self.cryptoMarketData else { return }
        
        let detailViewController = DetailViewController(data: data[indexPath.row])

        navigationController?.pushViewController(detailViewController, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: EditListDelegate

extension ViewController: EditListDelegate {
    func launchEditList(_ sender: UIButton) {
        let editListViewController = EditListViewController()
        editListViewController.delegate = self
        let navViewController = UINavigationController(rootViewController: editListViewController)
        self.present(navViewController, animated: true) {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        
    }
}

extension ViewController: RefreshDelegate {
    func refreshTableView() {
        self.loadDataFromUserDefaults()
        //self.refreshDataFromUserDefaults()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: BannerViewStateDelegate {
    func removeHeaderViewForFailedAdView() {
        removeBanner()
    }
    
    func addHeaderViewForRecievedAdView() {
        addBanner()
    }
}


// MARK: - UIViewControllerPreviewingDelegate

extension ViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPoint = tableView.convert(location, from: self.view)
        
        if let path = tableView.indexPathForRow(at: cellPoint) {
            let cell = tableView.cellForRow(at: path) as! TickerCell
            
            guard let data = self.cryptoMarketData else { return nil }
            
            let detailViewController = DetailViewController(data: data[path.row])
            
            previewingContext.sourceRect = self.view.convert(cell.frame, from: tableView)
            
            return detailViewController
        }
            
        return nil
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    
}

