//
//  FatGrayLabel.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/14/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import UIKit


class FatGrayLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.font = UIFont.boldSystemFont(ofSize: 14)
        self.sizeToFit()
        self.textColor = UIColor.darkerLightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

