//
//  GenericCollectionViewCell.swift
//  GenericViewKit
//
//  Created by Kristian Andersen on 29/05/16.
//  Copyright © 2016 Kristian Andersen. All rights reserved.
//

import UIKit

open class GenericCollectionViewCell: UICollectionViewCell, ConfigurableView {
    public override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        configureView()
        createConstraints()
    }
    
    public required init() {
        super.init(frame: CGRect.zero)
        configureView()
        createConstraints()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        createConstraints()
    }
    
    open func configureView() {}
    open func createConstraints() {}
}
