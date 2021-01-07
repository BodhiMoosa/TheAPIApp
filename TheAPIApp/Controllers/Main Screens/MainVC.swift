//
//  MainVC.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/15/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

final class MainVC: UIViewController {
    private var favorites               = DataManager.shared.getFavorites()
    private var tableOffset : CGFloat   = 0
    private let searchController        = UISearchController()
    private var isSearching             = false
    private var filteringData           : [Entry] = []
    private var tableView               = UITableView()
    private var backgroundView          = UIView()
    private var upButton                = UIBarButtonItem()
    private var searchButton            = UIBarButtonItem()
    private var apiData                 : [Entry] = []
    private let notificationName        = NSNotification.Name("updateViews")
    
    
    override func viewWillAppear(_ animated: Bool) {
        favorites = DataManager.shared.getFavorites()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configure()
        configureNavBar()
        createObserver()
    }
    
    override func viewDidLayoutSubviews() {
        if tableOffset == 0 {
            tableOffset = tableView.contentOffset.y
            setUpTableViewBackgroundImage(data: apiData)
        }
        createNavBarShadow()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(observedFunction), name: notificationName, object: nil)
    }
    
    @objc private func observedFunction() {
        favorites = DataManager.shared.getFavorites()
        tableView.reloadData()
    }
    
    @objc private func scrollUp() {
         let topRow = IndexPath(row: 0, section: 0)
         tableView.scrollToRow(at: topRow, at: .top, animated: true)
     }
    
    private func configure() {
        guard let title = title else { return }
        if title == "APIs" {
            configureSearchController()
            apiData = DataManager.shared.getAllAPIs()
        } else {
            apiData = DataManager.shared.getAPIsWithinCategory(category: title)
        }
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.separatorStyle    = .none
        tableView.tableFooterView   = UIView()
        tableView.rowHeight         = 75
        tableView.dataSource        = self
        tableView.delegate          = self
        tableView.register(APICell.self, forCellReuseIdentifier: APICell.reuseID)
        tableView.register(APIFillerCell.self, forCellReuseIdentifier: APIFillerCell.reuseID)
    }
    
    private func setUpTableViewBackgroundImage(data: [Entry]) {
        backgroundView.frame        = tableView.frame
        (data.count > 8) ? (displayBackgroundView(view: backgroundView)) : (displayEmptyBackgroundView(view: backgroundView))
        tableView.backgroundView    = backgroundView
        }
    
    private func configureNavBar() {
        if title == "APIs" {
            upButton                                            = UIBarButtonItem(title: "Top", style: .plain, target: self, action: #selector(scrollUp))
            upButton.tintColor                                  = .label
            navigationItem.rightBarButtonItem                   = upButton
            navigationController?.navigationBar.barTintColor    = .systemGray2
        } else {
            navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil)
        }
    }
    

    
 
 
}

//MARK: Table Delegate
extension MainVC : UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return CGFloat(75)
        } else {
            return CGFloat(1)
        }
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 != 0 {
            return
        }
        let singleAPI                   = isSearching ? filteringData[indexPath.row / 2] : apiData[indexPath.row / 2]
        let vc                          = APIDescriptionVC()
        vc.holder                       = singleAPI
        searchController.isActive       = false
        let presentingVC                = UINavigationController(rootViewController: vc)
        present(presentingVC, animated: true, completion: nil)
        searchController.searchBar.text = ""
        isSearching                     = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { //keeps table from scrolling beyond top but still able to scroll past bottom
        scrollView.bounces = scrollView.contentOffset.y > 0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var isFave          = false
        let dataToPullFrom  = isSearching ? filteringData : apiData
        if favorites.count != 0 {
            for x in favorites {
                if dataToPullFrom[indexPath.row / 2].api == x.api {
                    isFave = true
                }
            }
        }
        let title = isFave ? "Unfavorite" : "Favorite"
        let action = UIContextualAction(style: .normal, title: title) { [weak self] (action, view, completed) in
            guard let self = self else { return }
                if title == "Unfavorite" {
                    switch DataManager.shared.removeFavovorite(title: dataToPullFrom[indexPath.row / 2].api) {
                    case true:
                        self.favorites = DataManager.shared.getFavorites()
                    case false:
                        return
                    }
                } else {
                    switch DataManager.shared.saveFavorite(api: dataToPullFrom[indexPath.row / 2]) {
                    case true:
                        self.favorites = DataManager.shared.getFavorites()
                    case false:
                        self.presentAlertOnMainThread()
                    }
                }
            self.tableView.reloadData()
            completed(true)
        }
        action.backgroundColor  = .systemPink
        let swipeConfig         = UISwipeActionsConfiguration(actions: [action])
        return swipeConfig
    }
}

//MARK: Table DataSource
extension MainVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteringData.count * 2 : apiData.count * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 != 0 {
            let cell    = tableView.dequeueReusableCell(withIdentifier: APIFillerCell.reuseID) as! APIFillerCell
            return cell
        }
        let datasource  = isSearching ? filteringData : apiData
        var isFave      = false
        let cell        = tableView.dequeueReusableCell(withIdentifier: APICell.reuseID) as! APICell
        let entry       = datasource[indexPath.row / 2]
        cell.set(api: entry.api)
        
        for x in favorites {
            if x.api == entry.api {
                isFave = true
            }
        }
        cell.heart.image    = isFave ? StaticImages.heartFilled : StaticImages.heartEmpty
        cell.indexPath      = indexPath
        return cell
    }
}

// MARK: SearchController Delegates
extension MainVC : UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter    = searchController.searchBar.text, !filter.isEmpty else {
            isSearching     = false
            tableView.reloadData()
            return
        }
        filteringData       = apiData.filter { $0.api.lowercased().contains(filter.lowercased()) }
        setUpTableViewBackgroundImage(data: filteringData)
        isSearching         = true
        tableView.reloadData()
    }

    func configureSearchController() {
        let customPlaceholder = NSAttributedString(string: "Search through API collection!",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.5),
                                                  NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter", size: 14)!])
        searchController.searchResultsUpdater                               = self
        searchController.searchBar.delegate                                 = self
        searchController.obscuresBackgroundDuringPresentation               = false
        searchController.hidesNavigationBarDuringPresentation               = false
        searchController.searchBar.backgroundColor                          = .clear
        searchController.searchBar.searchTextField.attributedPlaceholder    = customPlaceholder
        navigationItem.searchController                                     = searchController
        navigationItem.hidesSearchBarWhenScrolling                          = false
        searchController.searchBar.searchTextField.backgroundColor          = UIColor.systemBlue.withAlphaComponent(0.5)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        setUpTableViewBackgroundImage(data: apiData)
        tableView.reloadData()
    }
}



