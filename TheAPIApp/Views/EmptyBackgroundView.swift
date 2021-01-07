//
//  EmptyBackgroundView.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/22/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//


import UIKit


class EmptyBackgroundView: UIView {

   let fontSize     = UIScreen.main.bounds.width/9
    let topCover    = UIView()
    let bottomCover = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {

        self.addSubview(topCover)
        self.addSubview(bottomCover)
        topCover.backgroundColor                                = .systemGray2
        topCover.translatesAutoresizingMaskIntoConstraints      = false
        bottomCover.translatesAutoresizingMaskIntoConstraints   = false
        bottomCover.backgroundColor                             = .systemGray4
        bottomCover.alpha                                       = 0.8
        backgroundColor                                         = .systemPink
 
        NSLayoutConstraint.activate([
            
            topCover.topAnchor.constraint(equalTo: self.topAnchor),
            topCover.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topCover.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topCover.heightAnchor.constraint(equalToConstant: 75),
            
            bottomCover.topAnchor.constraint(equalTo: topCover.bottomAnchor),
            bottomCover.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomCover.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomCover.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
