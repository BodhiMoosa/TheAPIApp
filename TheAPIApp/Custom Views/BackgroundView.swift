//
//  BackgroundView.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/20/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit


class BackgroundView: UIView {

   let fontSize     = UIScreen.main.bounds.width/9
    let logo        = UIImageView()
    var label       = CustomLabel()
    var label2      = CustomLabel()
    var label3      = CustomLabel()
    let topCover    = UIView()
    let bottomCover = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        label       = CustomLabel(text: "Nothing", size: fontSize, fontName: FontEnums.typewriterBold, alightment: .left)
        label2      = CustomLabel(text: "To See", size: fontSize, fontName: FontEnums.typewriterBold, alightment: .left)
        label3      = CustomLabel(text: "Here!", size: fontSize, fontName: FontEnums.typewriterBold, alightment: .left)
        
        self.addSubview(label)
        self.addSubview(label2)
        self.addSubview(label3)
        self.addSubview(topCover)
        self.addSubview(logo)
        self.addSubview(bottomCover)
        topCover.backgroundColor                                = .systemGray2
        topCover.translatesAutoresizingMaskIntoConstraints      = false
        bottomCover.translatesAutoresizingMaskIntoConstraints   = false
        logo.translatesAutoresizingMaskIntoConstraints          = false
        bottomCover.backgroundColor                             = .systemGray4
        bottomCover.alpha                                       = 0.8
        backgroundColor                                         = .systemPink
        logo.image                                              = UIImage(named: Assets.headlogo)
        let logoSize                                            = UIScreen.main.bounds.height/2
        let labelsLeadingOffset : CGFloat = 10
        
        NSLayoutConstraint.activate([
            
            topCover.topAnchor.constraint(equalTo: self.topAnchor),
            topCover.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topCover.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topCover.heightAnchor.constraint(equalToConstant: 100),
            
            label.bottomAnchor.constraint(equalTo: label2.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: labelsLeadingOffset),
            label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 30),
            label.heightAnchor.constraint(equalToConstant: label.font.lineHeight),
            
            label2.bottomAnchor.constraint(equalTo: label3.topAnchor),
            label2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: labelsLeadingOffset),
            label2.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 30),
            label2.heightAnchor.constraint(equalToConstant: label2.font.lineHeight),
            
            label3.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            label3.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: labelsLeadingOffset),
            label3.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 30),
            label3.heightAnchor.constraint(equalToConstant: label3.font.lineHeight),
            
            logo.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            logo.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: -10),
            logo.heightAnchor.constraint(equalToConstant: logoSize),
            logo.widthAnchor.constraint(equalToConstant: logoSize),
            
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
