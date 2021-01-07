//
//  UIViewController+Ext.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/17/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit
import WebKit
fileprivate var containerView: UIView!
fileprivate var categoryContainerView: UIView!

extension UIViewController {
    
    func displayLoadingView() {
        let activityIndicator                                       = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView                                               = UIView(frame: view.bounds)
        containerView.backgroundColor                               = UIColor.systemGray3.withAlphaComponent(0)
        view.addSubview(containerView)
        containerView.addSubview(activityIndicator)
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
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
    
    func presentAlertOnMainThread(subject: String? = nil, body: String? = nil) {
        DispatchQueue.main.async {
            var alertVC : AlertVC
            if (subject != nil && body != nil) {
                guard let subject = subject, let body = body else { return }
                alertVC = AlertVC(subject: subject, body: body)
            } else {
                alertVC = AlertVC()
            }
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func popUpPasteView() {
        let popUp   = CopyPopUpView()
        view.addSubview(popUp)
        popUp.alpha = 0
        popUp.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popUp.centerYAnchor.constraint(equalTo: view.centerYAnchor,  constant: -150),
            popUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popUp.heightAnchor.constraint(equalToConstant: 100),
            popUp.widthAnchor.constraint(equalToConstant: 250)
        ])
        UIView.animate(withDuration: 0.25) { popUp.alpha = 0.7 }
        UIView.animate(withDuration: 0.75, animations: { popUp.alpha = 0 }) { _ in
            popUp.removeFromSuperview()
        }
    }
    
    func createNavBarShadow() {
        guard let navigationBarBounds = navigationController?.navigationBar.bounds else { return }
        navigationController?.navigationBar.layer.shadowPath    = UIBezierPath(rect: navigationBarBounds).cgPath
        navigationController?.navigationBar.layer.shadowColor   = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowRadius  = 3
        navigationController?.navigationBar.layer.shadowOpacity = 0.25
        navigationController?.navigationBar.layer.shadowOffset  = CGSize(width: 0, height: 6)
    }

}


