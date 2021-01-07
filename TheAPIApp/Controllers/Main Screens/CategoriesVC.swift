//
//  CategoriesVC.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/16/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

final class CategoriesVC: UIViewController {
    
    private var isSearching     = false
    private let tableView       = UITableView()
    private var categoriesArray = DataManager.shared.getCategories()
    private var filteringData   : [String] = []
    private var backgroundView  = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
         if categoriesArray.count == 0 {
             categoriesArray = DataManager.shared.getCategories()
         }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        setupTableViewBackgroundImage()
        createNavBarShadow()
    }
    
    private func configureTableView() {
        tableView.dataSource        = self
        tableView.delegate          = self
        tableView.separatorStyle    = .none
        tableView.rowHeight         = 75
        tableView.register(APICell.self, forCellReuseIdentifier: APICell.reuseID)
        tableView.register(APIFillerCell.self, forCellReuseIdentifier: APIFillerCell.reuseID)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableViewBackgroundImage() {
                backgroundView.frame        = tableView.frame
                displayBackgroundView(view: backgroundView)
                tableView.backgroundView    = backgroundView
    }
}

//MARK: Table DataSource/Delegates
extension CategoriesVC : UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count == 0 ? 0 : categoriesArray.count * 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return CGFloat(75)
        } else {
            return CGFloat(1)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: APIFillerCell.reuseID) as! APIFillerCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: APICell.reuseID) as! APICell
            cell.set(api: categoriesArray[indexPath.row / 2])
            return cell
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc      = MainVC()
        vc.title    = categoriesArray[indexPath.row / 2]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //keeps table from scrolling beyond top but still able to scroll past bottom
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = (scrollView.contentOffset.y > 10)
    }
    
}

