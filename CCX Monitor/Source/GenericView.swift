//
//  GenericView.swift
//  GenericViewKit
//
//  Created by Kristian Andersen on 29/05/16.
//  Copyright © 2016 Kristian Andersen. All rights reserved.
//

import UIKit

open class GenericView: UIView, ConfigurableView {
    

    public required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
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
