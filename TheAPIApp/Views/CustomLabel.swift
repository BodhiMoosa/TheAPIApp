//
//  CustomLabel.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/16/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String, size: CGFloat, fontName: String, alightment: NSTextAlignment) {
        super.init(frame: .zero)
        self.text           = text
        self.font           = UIFont(name: fontName, size: size)
        self.textAlignment  = alightment
        configure()
    }
    
    private func configure() {
        textColor                       = .label
        adjustsFontSizeToFitWidth       = true
        minimumScaleFactor              = 0.50
        lineBreakMode                   = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
