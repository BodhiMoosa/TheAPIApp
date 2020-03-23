//
//  UIViewController+Ext.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/17/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit
fileprivate var containerView: UIView!
fileprivate var categoryContainerView: UIView!

extension UIViewController {
    
    func displayLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor = .systemGray3
        containerView.alpha = 0
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        activityIndicator.startAnimating()
    }

    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    func displayEmptyUsersView(view: UIView) {
        let coverView                       = UIView()
        coverView.frame                     = view.bounds
        coverView.backgroundColor           = .systemGray4
        coverView.alpha                     = 0.75
        let emptyStateView                  = EmptyView()
        emptyStateView.frame                = view.bounds
        view.addSubview(emptyStateView)
        view.addSubview(coverView)
    }
    
    func displayBackgroundView(view: UIView) {
        let backgroundView                  = BackgroundView()
        backgroundView.frame                = view.frame
        view.addSubview(backgroundView)
    }
    
    func displayEmptyBackgroundView(view: UIView) {
        let backgroundView                  = EmptyBackgroundView()
        backgroundView.frame                = view.frame
        view.addSubview(backgroundView)
    }
    
    func presentAlertOnMainThread() {
        DispatchQueue.main.async {
            let alertVC = AlertVC()
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    func presentEmailErrorOnMainThread() {
        DispatchQueue.main.async {
            let alertVC = EmailErrorVC()
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}


