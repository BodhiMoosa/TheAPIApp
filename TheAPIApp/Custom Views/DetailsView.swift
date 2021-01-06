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
    
    let apiDescription  = UITextView()
    let auth            = UITextField()
    let https           = UITextField()
    let cors            = UITextField()
    let link            = UITextField()
    let category        = UITextField()
    let emailButton     = EmailButton()
    let copyButton      = UIImageView(image: UIImage(systemName: "doc.on.clipboard"))
    
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
        apiDescription.text        = api.description
        if api.auth == "" {
            auth.text           = "Auth: None"
        } else {
            auth.text           = "Auth: " + api.auth!
        }
        https.text              = "HTTPS: " + String(api.https)
        cors.text               = "Cors: " + api.cors
        link.text               = api.link
        category.text           = "Category: " + api.category
        
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
        link.delegate                       = self
        auth.isUserInteractionEnabled       = false
        cors.isUserInteractionEnabled       = false
        https.isUserInteractionEnabled      = false
        category.isUserInteractionEnabled   = false
        apiDescription.isEditable           = false
        
        addSubview(apiDescription)
        addSubview(emailButton)
        addSubview(heartImage)
        addSubview(copyButton)
        
        heartImage.layer.shadowRadius       = 1
        heartImage.layer.shadowColor        = UIColor.black.cgColor
        heartImage.tintColor                = .systemRed
        heartImage.layer.shadowOpacity      = 1
        heartImage.layer.shadowOffset       = CGSize(width: 1, height: 1)
        heartImage.isUserInteractionEnabled = true
        let tapRec                          = UITapGestureRecognizer(target: self, action: #selector(heartTap))
        copyButton.isUserInteractionEnabled = true
        copyButton.tintColor                = .black
        let tapToCopy                       = UITapGestureRecognizer(target: self, action: #selector(copyLink))
        copyButton.addGestureRecognizer(tapToCopy)
        heartImage.addGestureRecognizer(tapRec)
        
        heartImage.translatesAutoresizingMaskIntoConstraints        = false
        apiDescription.translatesAutoresizingMaskIntoConstraints    = false
        emailButton.translatesAutoresizingMaskIntoConstraints       = false
        copyButton.translatesAutoresizingMaskIntoConstraints        = false
        apiDescription.backgroundColor                              = UIColor.clear
        
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
        guard let url = URL(string: link.text!) else { return false }
        UIApplication.shared.open(url)
        return false
    }
    
    @objc func copyLink() {
        pasteboard.string = link.text
        backToAPIDescriptionVCDelegate.presentCopyPopUp()
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        self.addGestureRecognizer(tap)
    }
    
    private func configureConstraints() {
        holderArray = [auth, https, cors, link, category]
        
        for x in holderArray {
            addSubview(x)
            x.translatesAutoresizingMaskIntoConstraints = false
            x.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            x.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: x == link ? -40 : -10).isActive = true
            x.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        NSLayoutConstraint.activate([
            
            heartImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            heartImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            heartImage.heightAnchor.constraint(equalToConstant: 30),
            heartImage.widthAnchor.constraint(equalTo: heartImage.heightAnchor),
            
            auth.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            https.topAnchor.constraint(equalTo: auth.bottomAnchor, constant: 10),
            cors.topAnchor.constraint(equalTo: https.bottomAnchor, constant: 10),
            link.topAnchor.constraint(equalTo: cors.bottomAnchor, constant: 10),
            category.topAnchor.constraint(equalTo: link.bottomAnchor, constant: 10),
            
           apiDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
           apiDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
           apiDescription.topAnchor.constraint(equalTo: category.bottomAnchor, constant: 10),
           apiDescription.bottomAnchor.constraint(equalTo: emailButton.topAnchor, constant: -10),
            
            emailButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            emailButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            emailButton.heightAnchor.constraint(equalToConstant: 40),
            emailButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            copyButton.heightAnchor.constraint(equalToConstant: 25),
            copyButton.widthAnchor.constraint(equalToConstant: 25),
            copyButton.leadingAnchor.constraint(equalTo: link.trailingAnchor),
            copyButton.centerYAnchor.constraint(equalTo: link.centerYAnchor)
        
        ])
    }
   
}

