//
//  APICell.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/16/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class APICell: UITableViewCell {

    static let reuseID = "APICell"
    
    var indexPath = IndexPath()
    let apiName = UILabel()
    let heart   = UIImageView()
    let separator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(apiName)
        apiName.textAlignment                               = .center
        apiName.translatesAutoresizingMaskIntoConstraints   = false
        self.backgroundColor                                = .systemGray4
        apiName.font                                        = UIFont(name: FontEnums.typewriter, size: 20)
        apiName.adjustsFontSizeToFitWidth                   = true
        apiName.minimumScaleFactor                          = 0.50
        
                                     
        
        addSubview(heart)
    
        heart.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([

            apiName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            apiName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            apiName.trailingAnchor.constraint(equalTo: heart.leadingAnchor, constant:  -10),
            apiName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            heart.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            heart.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            heart.widthAnchor.constraint(equalToConstant: 20),
            heart.heightAnchor.constraint(equalToConstant: 20),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            separator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
            
            
        
        ])
    }
    
    func set( api: String) {
        apiName.text = api
    }
}