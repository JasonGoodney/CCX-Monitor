//
//  GlobalMarketView.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/8/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit
import SnapKit
import EFAutoScrollLabel

@objc protocol EditListDelegate: class {
    @objc func launchEditList(_ sender: UIButton)
}

class GlobalMarketView: UIView {
    
    weak var delegate: EditListDelegate?
    
    var totalMarketCapUsd: Double?
    var total24hVolumeUsd: Double?
    var activeCurrencies: Int?
    var activeMarkets: Int?
    var bitcoinPercentageOfMarketCap: Double?
    
    let autoScrollLabel: EFAutoScrollLabel = {
        let label = EFAutoScrollLabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.labelSpacing = 40
        label.fadeLength = 15
        label.observeApplicationNotifications()
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5))
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    lazy var listButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(EditListDelegate.launchEditList(_:)), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "list").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    init(_ totalMarketCapUsd: Double, _ total24hVolumeUsd: Double,
                  _ activeCurrencies: Int, _ activeMarkets: Int, _ bitcoinPercentageOfMarketCap: Double) {
        self.totalMarketCapUsd = totalMarketCapUsd
        self.total24hVolumeUsd = total24hVolumeUsd
        self.activeCurrencies = activeCurrencies
        self.activeMarkets = activeMarkets
        self.bitcoinPercentageOfMarketCap = bitcoinPercentageOfMarketCap
        
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        super.init(frame: frame)
        
        addViews()
        addConstraints()
        updateLabelText()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    
    fileprivate func addViews() {
        addSubview(autoScrollLabel)
        addSubview(seperatorView)
        addSubview(listButton)
    }
    
    fileprivate func addConstraints() {
        autoScrollLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).inset(8)
            make.right.equalTo(self).inset(64)
            make.centerY.equalTo(self)
        }
        
        listButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).inset(16)
        }
    }
    
    fileprivate func updateLabelText() {
        let valueAttr: [NSAttributedStringKey : Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        ]
        
        let attributedStrings: [NSAttributedString] = [
            NSAttributedString(string: "\(String(describing: activeCurrencies!))", attributes: valueAttr),
            NSAttributedString(string: " • Markets: "), NSAttributedString(string: "\(String(describing: activeMarkets!))", attributes: valueAttr),
            NSAttributedString(string: " • Market Cap: "), NSAttributedString(string: "\(String.formatCurrency(value: totalMarketCapUsd,fractionDigits: 0))", attributes: valueAttr),
            NSAttributedString(string: " • 24h Volume: "), NSAttributedString(string: "\(String.formatCurrency(value: total24hVolumeUsd, fractionDigits: 0))", attributes: valueAttr),
            NSAttributedString(string: " • Bitcoin Market %: "), NSAttributedString(string: "\(String(format: "%.01f", bitcoinPercentageOfMarketCap!))", attributes: valueAttr)]
        
        let mutableAttributedString = NSMutableAttributedString(string: "Cryptocurrencies: ")

        for string in attributedStrings {
            mutableAttributedString.append(string)
        }
        
        autoScrollLabel.attributedText = mutableAttributedString
    }
    
    
}

extension GlobalMarketView: EditListDelegate {
    @objc func launchEditList(_ sender: UIButton) {
        self.delegate?.launchEditList(sender)
    }
}

enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
