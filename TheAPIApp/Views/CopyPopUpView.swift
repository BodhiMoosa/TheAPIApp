//
//  CopyPopUpView.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 4/2/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class CopyPopUpView: UIView {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        layer.borderColor                               = UIColor.black.cgColor
        layer.borderWidth                               = 1
        layer.cornerRadius                              = 19
        backgroundColor                                 = .systemPink
        label.textAlignment                             = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text                                      = "Copied!"
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
