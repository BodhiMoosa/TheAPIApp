//
//  HomeVC.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/15/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    let logoImageView = UIImageView()
    let mainLabel = CustomLabel(text: "API App", size: 75, fontName: StaticFonts.typewriter, alightment: .center)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        apiPull()
    }
    
    private func configure() {
        
        view.backgroundColor = .systemGray3
        view.addSubview(logoImageView)
        view.addSubview(mainLabel)
        self.navigationController?.navigationBar.isHidden = true
        
        logoImageView.image = StaticImages.fullLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mainLabel.heightAnchor.constraint(equalToConstant: mainLabel.font.lineHeight),
            
            logoImageView.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])

    }
    
    private func apiPull() {
        displayLoadingView()
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        Networkmanager.shared.getAPIS { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let apis):
                DispatchQueue.main.async {
                    let onboardAPIs = DataManager.shared.getAllAPIs()
                    for x in apis.entries {
                        if !onboardAPIs.contains(x) {
                            DataManager.shared.addNewAPI(api: x)
                        }
                    }
                    self.dismissLoadingView()
                    self.tabBarController?.tabBar.isUserInteractionEnabled = true
                }
            case .failure(_):
                DispatchQueue.main.sync {
                    let apis = DataManager.shared.getAllAPIs()
                    if apis.count != 0 {
                        self.tabBarController?.tabBar.isUserInteractionEnabled = true
                    }
                    self.dismissLoadingView()
                    self.presentAlertOnMainThread()

                }
            }
        }
    }
}
