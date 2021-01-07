//
//  APIDescriptionVC.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/16/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit
import MessageUI

class APIDescriptionVC: UIViewController {
    private var backgroundBaseView  = UIView()
    private var dataView            = DetailsView()
    var isDoneButton                = true
    var holder                      : Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        dataView.layer.shadowPath = UIBezierPath(roundedRect: dataView.bounds, cornerRadius: 10).cgPath
        dataView.emailButton.configureViewBorder(shadowRadius: dataView.emailButtonShadowRadius)
    }
    private func configure() {
        configureNavBar()
        guard let holder                                                = holder else { return }
        backgroundBaseView.backgroundColor                              = UIColor.systemBlue.withAlphaComponent(0.4)
        backgroundBaseView.translatesAutoresizingMaskIntoConstraints    = false
        backgroundBaseView.frame                                        = view.bounds
        view.backgroundColor                                            = .systemGray
        title                                                           = holder.api
        dataView                                                        = DetailsView(api: holder)
        dataView.backToAPIDescriptionVCDelegate                         = self
        dataView.translatesAutoresizingMaskIntoConstraints              = false
        let padding                                                     : CGFloat = 10
        view.addSubview(backgroundBaseView)
        view.addSubview(dataView)
        NSLayoutConstraint.activate([
            dataView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dataView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dataView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            dataView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    private func configureNavBar() {
        if isDoneButton {
            let doneButton                                  = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
            doneButton.tintColor                            = .label
            navigationItem.rightBarButtonItem               = doneButton
        }
        navigationController?.navigationBar.barTintColor    = .systemGray2
    }
}

extension APIDescriptionVC :  MFMailComposeViewControllerDelegate, BackToAPIDescriptionVCDelegate {
    func presentCopyPopUp() {
        self.popUpPasteView()
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
        
    func emailPopUp(api: Entry) {
            if MFMailComposeViewController.canSendMail() {
                let mail        = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([])
                var authFinal   = ""
                if api.auth == "" || api.auth == nil {
                    authFinal   = "None"
                } else {
                    authFinal   = api.auth!
                }
                let auth        = "\nAuthorzation: " + authFinal
                let name        = "API Name: " + api.api
                let cors        = "\nCORS: " + api.cors
                let category    = "\nCategory: " + api.category
                let link        = "\nLink: " + api.link
                let description = "\n\nDescription: " + api.description
                let body        = name + auth + cors + link + category + description
                mail.setMessageBody(body, isHTML: false)
                present(mail, animated: true, completion: nil)
        } else {
            presentAlertOnMainThread(subject: "Cannot Send Email", body: "Something went wrong. Please try again later.")
        }
    }
    
    func favoriteToggle() {
        guard let holder = holder else { return }
        if !dataView.isFavorite {
            switch DataManager.shared.saveFavorite(api: holder) {
            case true:
                dataView.heartImage.image              = StaticImages.heartFilled
                dataView.isFavorite                    = true
                dataView.heartImage.layer.shadowRadius = 0
            case false:
                return
            }
            dataView.heartImage.image                   = StaticImages.heartFilled
            dataView.isFavorite                         = true
            dataView.heartImage.layer.shadowRadius      = 0
        } else {
            switch DataManager.shared.removeFavovorite(title: holder.api) {
            case true:
                dataView.heartImage.image               = StaticImages.heartEmpty
                dataView.heartImage.layer.shadowRadius  = 1
                dataView.isFavorite                     = false
            case false:
                return
                
            }
            dataView.heartImage.image                = StaticImages.heartEmpty
            dataView.heartImage.layer.shadowRadius   = 1
            dataView.isFavorite                      = false
        }
        NotificationCenter.default.post(name: NSNotification.Name("updateViews"), object: nil)
    }
}

