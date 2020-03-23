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
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 10
        backgroundColor = .systemGray3
        setTitleColor(.black, for: .normal)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3
        titleLabel?.font = UIFont(name: "AmericanTypewriter", size: 18)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
