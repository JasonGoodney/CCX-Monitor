//
//  Extensions.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/19/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit
import Foundation


protocol ButtonAnimations {
    func pulsate(layer: CALayer)
    func animationScaleEffect(view:UIView,animationTime:Float)
}

extension ButtonAnimations {
    func pulsate(layer: CALayer) {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.75
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func animationScaleEffect(view:UIView,animationTime:Float)
    {
        UIView.animate(withDuration: TimeInterval(animationTime), animations: {
            
            view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            
        },completion:{completion in
            UIView.animate(withDuration: TimeInterval(animationTime), animations: { () -> Void in
                
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
        
    }
}

extension UIButton: ButtonAnimations {}
extension UIBarButtonItem: ButtonAnimations {}

extension UIImage{
    
    class func imageFromSystemBarButton(_ systemItem: UIBarButtonSystemItem, renderingMode:UIImageRenderingMode = .automatic)-> UIImage {
        
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        UIToolbar().setItems([tempItem], animated: false)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        
        for view in itemView.subviews {
            if view is UIButton {
                let button = view as! UIButton
                let image = button.imageView!.image!
                image.withRenderingMode(renderingMode)
                return image
            }
        }
        
        return UIImage()
    }
}

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



