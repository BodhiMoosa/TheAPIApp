//
//  DetailsView.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/16/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit
import MessageUI

protocol BackToAPIDescriptionVCDelegate : class {
    func emailPopUp(api: Entry)
    func presentCopyPopUp()
    func favoriteToggle()
}
class DetailsView: UIView, UITextFieldDelegate {
    
    let pasteboard = UIPasteboard.general
    var isFavorite = false
    let heartImage = UIImageView()
    weak var backToAPIDescriptionVCDelegate : BackToAPIDescriptionVCDelegate!
    var api : Entry!
    var holderArray : [UITextField]!
    
    let Description = UITextView()
    let Auth        = UITextField()
    let HTTPS       = UITextField()
    let Cors        = UITextField()
    let Link        = UITextField()
    let Category    = UITextField()
    let emailButton = EmailButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func updateFaveImage() {
        isFavorite = DataManager.shared.checkFavorite(name: api.api)
        if isFavorite {
            heartImage.image = StaticImages.heartFilled
        } else {
            heartImage.image = StaticImages.heartEmpty
        }
    }

    override func didMoveToWindow() {
        updateFaveImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(api: Entry) {
        super.init(frame: .zero)
        self.api                = api
        Description.text        = api.description
        if api.auth == "" {
            Auth.text           = "Auth: None"
        } else {
            Auth.text           = "Auth: " + api.auth!
        }
        HTTPS.text              = "HTTPS: " + String(api.https)
        Cors.text               = "Cors: " + api.cors
        Link.text               = api.link
        Category.text           = "Category: " + api.category
        
        configure()
        configureConstraints()
    }
    private func configure() {
        updateFaveImage()
        dismissKeyboard()
        backgroundColor                     = .systemGray4
        layer.cornerRadius                  = 10
        layer.shadowColor                   = UIColor.black.cgColor
        layer.shadowOpacity                 = 0.5
        layer.shadowRadius                  = 5
        layer.borderColor                   = UIColor.gray.cgColor
        layer.borderWidth                   = 1
        Link.delegate                       = self
        Auth.isUserInteractionEnabled       = false
        Cors.isUserInteractionEnabled       = false
        HTTPS.isUserInteractionEnabled      = false
        Category.isUserInteractionEnabled   = false
        Description.isEditable              = false
        
        addSubview(Description)
        addSubview(emailButton)
        addSubview(heartImage)
        
        heartImage.layer.shadowRadius       = 1
        heartImage.layer.shadowColor        = UIColor.black.cgColor
        heartImage.layer.shadowOpacity      = 1
        heartImage.layer.shadowOffset       = CGSize(width: 1, height: 1)
        heartImage.isUserInteractionEnabled = true
        let tapRec                          = UITapGestureRecognizer()
        tapRec.addTarget(self, action: #selector(heartTap))
        heartImage.addGestureRecognizer(tapRec)
        
        heartImage.translatesAutoresizingMaskIntoConstraints    = false
        Description.translatesAutoresizingMaskIntoConstraints   = false
        emailButton.translatesAutoresizingMaskIntoConstraints   = false

        Description.backgroundColor                             = UIColor.clear
        
        emailButton.setTitle("Email", for: .normal)
        emailButton.addTarget(self, action: #selector(emailAction), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(shadowDrop), for: .touchDown)
    }
    @objc func heartTap() {
        backToAPIDescriptionVCDelegate.favoriteToggle()
    }
    @objc func emailAction() {
        emailButton.layer.shadowRadius  = 5
        emailButton.titleLabel?.font    = UIFont(name: "AmericanTypewriter", size: 18)
        backToAPIDescriptionVCDelegate.emailPopUp(api: api)
    }
    
    @objc func shadowDrop() {
        emailButton.layer.shadowRadius  = 0
        emailButton.titleLabel?.font    = UIFont(name: "AmericanTypewriter", size: 16)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pasteboard.string = Link.text
        backToAPIDescriptionVCDelegate.presentCopyPopUp()
        return false
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        self.addGestureRecognizer(tap)
    }
    
    private func configureConstraints() {
        holderArray = [Auth, HTTPS, Cors, Link, Category]
        
        for x in holderArray {
            addSubview(x)
            x.translatesAutoresizingMaskIntoConstraints = false
            x.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            x.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
            x.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        NSLayoutConstraint.activate([
            
            heartImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            heartImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            heartImage.heightAnchor.constraint(equalToConstant: 30),
            heartImage.widthAnchor.constraint(equalTo: heartImage.heightAnchor),
            
            Auth.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            HTTPS.topAnchor.constraint(equalTo: Auth.bottomAnchor, constant: 10),
            Cors.topAnchor.constraint(equalTo: HTTPS.bottomAnchor, constant: 10),
            Link.topAnchor.constraint(equalTo: Cors.bottomAnchor, constant: 10),
            Category.topAnchor.constraint(equalTo: Link.bottomAnchor, constant: 10),
            
            Description.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            Description.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            Description.topAnchor.constraint(equalTo: Category.bottomAnchor, constant: 10),
            Description.bottomAnchor.constraint(equalTo: emailButton.topAnchor, constant: -10),
            
            emailButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            emailButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            emailButton.heightAnchor.constraint(equalToConstant: 40),
            emailButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        
        ])
    }
}
