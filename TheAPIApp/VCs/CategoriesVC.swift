//
//  CategoriesVC.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/16/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController {
    
    var isSearching = false
    let tableView = UITableView()
    var categoriesArray = DataManager.shared.getCategories()
    var filteringData : [String] = []
    var backgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if categoriesArray.count == 0 {
            categoriesArray = DataManager.shared.getCategories()
        }
    }
    
    override func viewDidLayoutSubviews() {
        setupTableViewBackgroundImage()
    }
    
    private func configureTableView() {
        tableView.dataSource        = self
        tableView.delegate          = self
        tableView.separatorStyle    = .none
        tableView.rowHeight         = 75
        tableView.register(APICell.self, forCellReuseIdentifier: APICell.reuseID)
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
                backgroundView.frame = tableView.frame
                displayBackgroundView(view: backgroundView)
                tableView.backgroundView = backgroundView
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowRadius = 3
        navigationController?.navigationBar.layer.shadowOpacity = 0.25
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 6)
    }
}

extension CategoriesVC : UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count == 0 ? 0 : categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: APICell.reuseID) as! APICell
        cell.set(api: categoriesArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MainVC()
        vc.title = categoriesArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { //keeps table from scrolling beyond top but still able to scroll past bottom
        scrollView.bounces = (scrollView.contentOffset.y > 10)
    }
    
}

