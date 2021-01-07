//
//  FavoritesVC.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/19/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit
import MessageUI

class FavoritesVC: UIViewController {
    
    var tableData : [Entry] = []
    let tableView           = UITableView()
    var backgroundView      = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableData = DataManager.shared.getFavorites()
        configureTableView()
        configure()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableData = DataManager.shared.getFavorites()
        tableView.reloadData()
        if tableData.count == 0 {
            self.displayEmptyUsersView(view: self.view)
        } else {
            self.view.bringSubviewToFront(tableView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        setUpTableViewBackgroundImage()
        createNavBarShadow()
        
    }
    
    private func configure() {
        let emailButton                     = UIBarButtonItem(image: StaticImages.plane, style: .plain, target: self, action: #selector(email))
        navigationItem.rightBarButtonItem   = emailButton
    }

    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        tableView.register(APICell.self, forCellReuseIdentifier: APICell.reuseID)
        tableView.register(APIFillerCell.self, forCellReuseIdentifier: APIFillerCell.reuseID)
        tableView.backgroundColor   = UIColor.systemGray4
        tableView.separatorStyle    = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight         = 75
        tableView.delegate          = self
        tableView.dataSource        = self
    }
    
    private func setUpTableViewBackgroundImage() {
        backgroundView.frame        = tableView.frame
        if tableData.count > 8 {
            displayBackgroundView(view: backgroundView)
        } else {
            displayEmptyBackgroundView(view: backgroundView)
        }
        tableView.backgroundView    = backgroundView
    }
}

extension FavoritesVC : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count * 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row % 2 == 0 ? CGFloat(75) : CGFloat(1)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: APIFillerCell.reuseID) as! APIFillerCell
            return cell

        }
        let cell            = tableView.dequeueReusableCell(withIdentifier: APICell.reuseID) as! APICell
        cell.apiName.text   = tableData[indexPath.row / 2].api
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc                  = APIDescriptionVC()
        vc.holder               = tableData[indexPath.row / 2]
        vc.isDoneButton         = false
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action              = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completed) in
            guard let self      = self else { return }
            switch DataManager.shared.removeFavovorite(title: self.tableData[indexPath.row / 2].api) {
            
            case true:
                self.tableData.remove(at: indexPath.row / 2)
            case false:
                return
            }
            self.tableView.reloadData()
            if self.tableData.count == 0 {
                self.displayEmptyUsersView(view: self.view)
            }
            completed(true)
        }
        let swipeConfig = UISwipeActionsConfiguration(actions: [action])
        return swipeConfig
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { //keeps table from scrolling beyond top but still able to scroll past bottom
        if tableData.count > 8 {
            scrollView.bounces = (scrollView.contentOffset.y > 0)
        } else {
            scrollView.bounces = false
        }
    }    
}

extension FavoritesVC : MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        return
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @objc func email() {
        var bodyText = ""
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([])
            for x in tableData {
                let name = "Name: " + x.api + "\n"
                var authFinal = ""
                    if x.auth == "" || x.auth == nil {
                        authFinal = "None"
                    } else {
                        authFinal = x.auth!
                    }
                let auth = "\nAuthorzation: " + authFinal + "\n"
                let cors = "Cors: " + x.cors + "\n"
                let category = "Category: " + x.category + "\n"
                let description = "Description: " + x.description + "\n\n\n"
                let link = x.link + "\n"
                let section = name + auth + cors + category + link + description
                bodyText.append(section)
            }
            mail.setMessageBody(bodyText, isHTML: false)
            mail.setSubject("My Favorite APIs")
            present(mail, animated: true, completion: nil)
    } else {
        presentAlertOnMainThread(subject: "Can't Send Email", body: "Something went wrong. Please try again later.")
        }
    }
}
