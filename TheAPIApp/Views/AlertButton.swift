//
//  AlertButton.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/23/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class AlertButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        backgroundColor         = .systemGray3
        titleLabel?.font        = UIFont(name: "AmericanTypewriter", size: 18)
        setTitleColor(.black, for: .normal)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
