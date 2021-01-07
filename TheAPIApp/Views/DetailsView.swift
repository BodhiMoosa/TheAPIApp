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
class DetailsView: UIView {
    
    let pasteboard                          = UIPasteboard.general
    var isFavorite                          = false
    let heartImage                          = UIImageView()
    weak var backToAPIDescriptionVCDelegate : BackToAPIDescriptionVCDelegate!
    var api                                 : Entry!
    var holderArray                         : [UILabel] = []
    let apiDescription                      = UITextView()
    let auth                                = UILabel()
    let https                               = UILabel()
    let cors                                = UILabel()
    let link                                = UILabel()
    let category                            = UILabel()
    let emailButton                         = EmailButton()
    let copyButton                          = UIImageView(image: UIImage(systemName: "doc.on.clipboard"))
    var emailButtonShadowRadius             : CGFloat = 5
    
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
        apiDescription.text     = api.description

        https.text              = "HTTPS: " + String(api.https)
        cors.text               = "Cors: " + api.cors
        link.text               = api.link
        category.text           = "Category: " + api.category
        if api.auth == "" {
            auth.text           = "Auth: None"
        } else {
            auth.text           = "Auth: " + (api.auth ?? "None")
        }

        configure()
        configureConstraints()
    }
    private func configure() {
        updateFaveImage()
        dismissKeyboard()
        layoutIfNeeded()
        backgroundColor                     = .systemGray4
        layer.cornerRadius                  = 10
        layer.shadowColor                   = UIColor.black.cgColor
        layer.shadowOpacity                 = 0.5
        layer.shadowRadius                  = 5
        layer.borderColor                   = UIColor.gray.cgColor
        layer.borderWidth                   = 1
        apiDescription.isEditable           = false
        
        addSubview(apiDescription)
        addSubview(emailButton)
        addSubview(heartImage)
        addSubview(copyButton)
        
        heartImage.layer.shouldRasterize    = true
        heartImage.layer.rasterizationScale = UIScreen.main.scale
        heartImage.layer.shadowRadius       = 1
        heartImage.layer.shadowColor        = UIColor.black.cgColor
        heartImage.tintColor                = .systemRed
        heartImage.layer.shadowOpacity      = 1
        heartImage.layer.shadowOffset       = CGSize(width: 1, height: 1)
        heartImage.isUserInteractionEnabled = true
        
        let tapRec                          = UITapGestureRecognizer(target: self, action: #selector(heartTap))
        let tapToCopy                       = UITapGestureRecognizer(target: self, action: #selector(copyLink))
        let tapGoToLink                     = UITapGestureRecognizer(target: self, action: #selector(goToLink))
        apiDescription.backgroundColor      = UIColor.clear
        copyButton.isUserInteractionEnabled = true
        copyButton.tintColor                = .label
        link.isUserInteractionEnabled       = true
        link.addGestureRecognizer(tapGoToLink)
        copyButton.addGestureRecognizer(tapToCopy)
        heartImage.addGestureRecognizer(tapRec)
        emailButton.setTitle("Email", for: .normal)
        emailButton.addTarget(self, action: #selector(emailAction), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(shadowDrop), for: .touchDown)
        heartImage.translatesAutoresizingMaskIntoConstraints        = false
        apiDescription.translatesAutoresizingMaskIntoConstraints    = false
        emailButton.translatesAutoresizingMaskIntoConstraints       = false
        copyButton.translatesAutoresizingMaskIntoConstraints        = false
    }
    @objc func heartTap() {
        backToAPIDescriptionVCDelegate.favoriteToggle()
    }
    @objc func emailAction() {
        emailButtonShadowRadius         = 5
        emailButton.titleLabel?.font    = UIFont(name: "AmericanTypewriter", size: 18)
        backToAPIDescriptionVCDelegate.emailPopUp(api: api)
    }
    
    @objc func shadowDrop() {
        emailButtonShadowRadius         = 0
        emailButton.titleLabel?.font    = UIFont(name: "AmericanTypewriter", size: 17)

    }
    
    @objc func goToLink() {
        guard let url = URL(string: link.text!) else { return }
        UIApplication.shared.open(url)
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

