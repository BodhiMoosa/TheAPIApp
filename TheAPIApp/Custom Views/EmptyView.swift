//
//  EmptyView.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/19/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    
    let logo    = UIImageView()
    var label   = CustomLabel()
    var label2  = CustomLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    private func configure() {

        let labelheight                                 = UIScreen.main.bounds.height/7
        let logoSize                                    = UIScreen.main.bounds.height/2
        let logoOffset                                  = logoSize * 0.3
        let fontSize                                    = UIScreen.main.bounds.width/10
        label                                           = CustomLabel(text: "You have no favorites.", size: fontSize, fontName: StaticFonts.typewriter, alightment: .center)
        label2                                          = CustomLabel(text: "Go add some!", size: fontSize, fontName: StaticFonts.typewriter, alightment: .center)
        backgroundColor                                 = .systemPink
        logo.image                                      = StaticImages.headlogo
        logo.translatesAutoresizingMaskIntoConstraints  = false
        addSubview(logo)
        addSubview(label)
        addSubview(label2)

        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            label.heightAnchor.constraint(equalToConstant: labelheight),
            
            label2.topAnchor.constraint(equalTo: self.label.bottomAnchor),
            label2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            label2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            label2.heightAnchor.constraint(equalToConstant: labelheight),

            logo.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            logo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: logoOffset),
            logo.heightAnchor.constraint(equalToConstant: logoSize),
            logo.widthAnchor.constraint(equalToConstant: logoSize)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
