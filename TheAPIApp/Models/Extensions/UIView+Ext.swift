//
//  UIView+Ext.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 1/7/21.
//  Copyright © 2021 Tayler Moosa. All rights reserved.
//

import UIKit

extension UIView {
    
    func configureViewBorder(borderColor : UIColor = .gray, corderRadius: CGFloat = 0, shadowRadius: CGFloat = 5) {
        layer.borderWidth       = 1
        layer.borderColor       = UIColor.gray.cgColor
        layer.cornerRadius      = corderRadius
        backgroundColor         = .systemGray3
        layer.shadowPath        = UIBezierPath(roundedRect: self.bounds, cornerRadius: corderRadius).cgPath
        layer.shadowColor       = UIColor.gray.cgColor
        layer.shadowOffset      = .zero
        layer.shadowOpacity     = 0.5
        layer.shadowRadius      = shadowRadius
    }
}
