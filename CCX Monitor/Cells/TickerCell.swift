//
//  TickerCell.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/5/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit
import SnapKit
import CryptoMarketDataKit

class TickerCell: UITableViewCell {
    
    static public func reuseIdentifier() -> String {
        return "TickerCell"
    }
    
    fileprivate let inset = 16

    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        return label
    }()
    
    public lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.heavy)
        label.textColor = UIColor.darkerLightGray
        return label
    }()
    
    public lazy var priceCountryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        return label
    }()
    
    public lazy var change24hLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        addConstraints()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(nameLabel)
        addSubview(symbolLabel)
        addSubview(change24hLabel)
        addSubview(priceCountryLabel)
        
    }
    
    func addConstraints() {
        symbolLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).inset(16)
        }
    
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.left.equalTo(self).inset(16)
        }
                
        var changedFrame = symbolLabel.frame
        changedFrame.origin.y = CGFloat(ceilf(Float(nameLabel.frame.origin.y + (nameLabel.font.ascender - symbolLabel.font.ascender))))
        
        change24hLabel.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(self).inset(16)
        }
        
        priceCountryLabel.snp.makeConstraints { (make) in
            make.top.right.equalTo(self).inset(16)
        }
    }

    func configureWithCell(_ crypto: CryptoMarketData) {
        nameLabel.text = crypto.name
        symbolLabel.text = crypto.symbol
        
        if let priceUsd = crypto.priceUsd.toDouble() {
            priceCountryLabel.text = "\(String.formatCurrency(value: priceUsd, fractionDigits: 2)) $"
        }
        
        if let percentChanged = crypto.percentChange24h.toDouble() {
            var color = UIColor()
            switch percentChanged {
            case _ where percentChanged > 0:
                color = UIColor.xMasGreen
            case _ where percentChanged < 0:
                color = UIColor.xMasRed
            default:
                color = .lightGray
            }
            
            let text = NSMutableAttributedString(string: "", attributes: [.foregroundColor: UIColor.darkerLightGray, .font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)])
            let attrs: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)]
            text.append(NSAttributedString(string: "\(String.twoDigitsFormatted(percentChanged)) %", attributes: attrs))
            change24hLabel.attributedText = text
            
            
        }
    }
}


