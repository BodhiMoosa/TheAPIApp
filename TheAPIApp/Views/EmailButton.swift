//
//  EmailButton.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/17/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class EmailButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        backgroundColor     = .systemGray3
        setTitleColor(.black, for: .normal)
        titleLabel?.font    = UIFont(name: "AmericanTypewriter", size: 18)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

