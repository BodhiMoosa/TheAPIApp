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
    
    var dataView        = DetailsView()
    var isDoneButton    = true
    var holder : Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureNavBar()
        guard let holder                        = holder else { return }
        view.backgroundColor                    = .systemBackground
        title                                   = holder.API
        dataView                                = DetailsView(api: holder)
        dataView.backToAPIDescriptionVCDelegate = self
        view.addSubview(dataView)
        dataView.translatesAutoresizingMaskIntoConstraints = false
        let padding : CGFloat = 10
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
            let doneButton                                      = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
            doneButton.tintColor                                = .label
            navigationItem.rightBarButtonItem                   = doneButton
        }
        navigationController?.navigationBar.barTintColor        = .systemGray2
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
                if api.Auth == "" || api.Auth == nil {
                    authFinal   = "None"
                } else {
                    authFinal   = api.Auth!
                }
                let auth        = "\nAuthorzation: " + authFinal
                let name        = "API Name: " + api.API
                let cors        = "\nCORS: " + api.Cors
                let category    = "\nCategory: " + api.Category
                let link        = "\nLink: " + api.Link
                let description = "\n\nDescription: " + api.Description
                let body        = name + auth + cors + link + category + description
                mail.setMessageBody(body, isHTML: false)
                
                present(mail, animated: true, completion: nil)
            
        } else {
            presentEmailErrorOnMainThread()
        }
    }
    
    func favoriteToggle() {
        guard let holder = holder else { return }
        if !dataView.isFavorite {
            
            DataManager.shared.saveFavorite(api: holder) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.dataView.heartImage.image = StaticImages.heartFilled
                        self.dataView.isFavorite = true
                        self.dataView.heartImage.layer.shadowRadius = 0
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            dataView.heartImage.image                = StaticImages.heartFilled
            dataView.isFavorite                      = true
            dataView.heartImage.layer.shadowRadius   = 0
        } else {
            DataManager.shared.removeFavovorite(title: holder.API) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.dataView.heartImage.image               = StaticImages.heartEmpty
                        self.dataView.heartImage.layer.shadowRadius  = 1
                        self.dataView.isFavorite                     = false
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            dataView.heartImage.image                = StaticImages.heartEmpty
            dataView.heartImage.layer.shadowRadius   = 1
            dataView.isFavorite                      = false
        }
        NotificationCenter.default.post(name: NSNotification.Name("updateViews"), object: nil)
    }
}

