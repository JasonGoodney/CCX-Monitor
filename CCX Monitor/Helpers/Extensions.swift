//
//  Extensions.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/19/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    static var xMasRed: UIColor {
        return UIColor(red:0.90, green:0.22, blue:0.21, alpha:1.0)
    }
    
    static var xMasGreen: UIColor {
        return UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
    }
    
    static var darkerLightGray: UIColor {
        return UIColor(red:0.51, green:0.51, blue:0.55, alpha:1.0)
    }
    
    static var vegaBlack: UIColor {
        return UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
    }
    
    static var navyBlue: UIColor = #colorLiteral(red: 0.1128437743, green: 0.1638226509, blue: 0.2036182284, alpha: 1)
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



