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
    }
    
    private func configure() {
        let emailButton                     = UIBarButtonItem(image: StaticImages.plane, style: .plain, target: self, action: #selector(email))
        navigationItem.rightBarButtonItem   = emailButton
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowRadius = 3
        navigationController?.navigationBar.layer.shadowOpacity = 0.25
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 6)
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
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell            = tableView.dequeueReusableCell(withIdentifier: APICell.reuseID) as! APICell
        cell.apiName.text   = tableData[indexPath.row].api
        guard let last      = tableData.last else { return cell }
        if cell.apiName.text == last.api {
            cell.separator.isHidden = true
        } else {
            cell.separator.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc                  = APIDescriptionVC()
        vc.holder               = tableData[indexPath.row]
        vc.isDoneButton         = false
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action              = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completed) in
            guard let self      = self else { return }
            DataManager.shared.removeFavovorite(title: self.tableData[indexPath.row].api) { (result) in
                switch result {
                case .success(_):
                    self.tableData.remove(at: indexPath.row)
                case .failure(let error):
                    print(error.localizedDescription)
                }
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
        presentEmailErrorOnMainThread()
        }
    }
}
