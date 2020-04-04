//
//  AlertVC.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/23/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {
        
    let containerView       = UIView()
    let titleLabel          = CustomLabel(text: "Data Sync Error", size: 20, fontName: StaticFonts.typewriterBold, alightment: .center)
    let messageLabel        = CustomLabel(text: "Unable to check for new data. No worries though! We'll just check next time.", size: 12, fontName: StaticFonts.typewriter, alightment: .center)
    let actionButton        = AlertButton()
    let padding : CGFloat   = 20

        init() {
            super.init(nibName: nil, bundle: nil)
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
            configureContainerView()
            configureTitleLabel()
            configureActionButton()
            configureMessageLabel()
            super.viewDidLoad()
        }

        private func configureContainerView() {
            view.addSubview(containerView)
            containerView.backgroundColor                           = .systemBackground
            containerView.layer.cornerRadius                        = 16
            containerView.layer.borderWidth                         = 2
            containerView.layer.borderColor                         = UIColor.white.cgColor
            containerView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                containerView.widthAnchor.constraint(equalToConstant: 280),
                containerView.heightAnchor.constraint(equalToConstant: 220)
            ])
        }
        
        private func configureTitleLabel() {
            containerView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
                titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
                titleLabel.heightAnchor.constraint(equalToConstant: 28)
            ])
        }
        
        private func configureActionButton() {
            containerView.addSubview(actionButton)
            actionButton.translatesAutoresizingMaskIntoConstraints = false
            actionButton.setTitle("Continue", for: .normal)
            actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
            NSLayoutConstraint.activate([
                actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
                actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
                actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
                actionButton.heightAnchor.constraint(equalToConstant: 44)
                ])
        }
        
        @objc func dismissVC() {
            dismiss(animated: true)
        }

        func configureMessageLabel() {
            containerView.addSubview(messageLabel)
            messageLabel.numberOfLines                              = 3
            messageLabel.translatesAutoresizingMaskIntoConstraints  = false
            
            NSLayoutConstraint.activate([
                messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
                messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
                messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: 8)
            ])
        }
    }
