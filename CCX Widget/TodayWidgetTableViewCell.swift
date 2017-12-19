//
//  TodayWidgetTableViewCell.swift
//  CCX Widget
//
//  Created by Jason Goodney on 12/15/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit
import SnapKit
import CryptoMarketDataKit

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

class TodayWidgetTableViewCell: UITableViewCell {
    
    public lazy var symbolLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public lazy var priceCountryLabel: UILabel = {
        let label = UILabel()
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
        addSubview(symbolLabel)
        addSubview(priceCountryLabel)
        addSubview(change24hLabel)
    }
    
    func addConstraints() {
        symbolLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).inset(16)
        }

        change24hLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).inset(16)
        }
        
        priceCountryLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(change24hLabel).offset(16)
        }   
    }
    
    func configureWithCell(_ crypto: CryptoMarketData) {
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
                color = .black
            }
            
//            let text = NSMutableAttributedString(string: "", attributes: [.foregroundColor: UIColor.darkerLightGray, .font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)])
//
//            let attrs: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)]
//            text.append(NSAttributedString(string: "\(String.twoDigitsFormatted(percentChanged)) %", attributes: attrs))
            
            change24hLabel.text = "\(String.twoDigitsFormatted(percentChanged)) %"
            change24hLabel.textColor = color
            
            
        }
    }
    
}

extension TodayWidgetTableViewCell: ReusableView {
    
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    static func twoDigitsFormatted(_ val: Double) -> String {
        return String(format: "%.0.2f", val)
    }
    
    static func formatCurrency(value: Double?, fractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = fractionDigits
        //formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value! as NSNumber)
        return result!
    }
}

extension UIColor {
    static var xMasRed: UIColor {
        return UIColor(red:0.90, green:0.22, blue:0.21, alpha:1.0)
    }
    
    static var xMasGreen: UIColor {
        return UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
    }

}
