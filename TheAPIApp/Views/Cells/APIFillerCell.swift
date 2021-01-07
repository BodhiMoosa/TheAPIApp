//
//  APIFillerCell.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 1/6/21.
//  Copyright © 2021 Tayler Moosa. All rights reserved.
//

import UIKit

class APIFillerCell: UITableViewCell {
    
    
    static let reuseID = "APIFillerCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor    = .systemBlue
        selectionStyle          = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

