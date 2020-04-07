//
//  MainVC.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/15/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    var favorites               = DataManager.shared.getFavorites()
    var tableOffset : CGFloat   = 0
    let searchController        = UISearchController()
    var isSearching             = false
    var filteringData : [Entry] = []
    var tableView               = UITableView()
    var backgroundView          = UIView()
    var upButton                = UIBarButtonItem()
    var searchButton            = UIBarButtonItem()
    var apiData : [Entry] = []
    let notificationName = NSNotification.Name("updateViews")
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configure()
        configureNavBar()
        createObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(test), name: notificationName, object: nil)
    }
    
    @objc func test() {
        favorites = DataManager.shared.getFavorites()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites = DataManager.shared.getFavorites()
        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        if tableOffset == 0 {
            tableOffset = tableView.contentOffset.y
            setUpTableViewBackgroundImage(data: apiData)
        }
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
        tableView.tableFooterView = UIView()
        tableView.rowHeight         = 75
        tableView.dataSource        = self
        tableView.delegate          = self
        tableView.register(APICell.self, forCellReuseIdentifier: APICell.reuseID)
    }
    
    private func setUpTableViewBackgroundImage(data: [Entry]) {
        backgroundView.frame = tableView.frame
        (data.count > 8) ? (displayBackgroundView(view: backgroundView)) : (displayEmptyBackgroundView(view: backgroundView))
        tableView.backgroundView = backgroundView
        }
    
    private func configureNavBar() {
        if title == "APIs" {
            upButton                                            = UIBarButtonItem(title: "Top", style: .plain, target: self, action: #selector(scrollUp))
            upButton.tintColor                                  = .label
            navigationItem.rightBarButtonItem                   = upButton
        } else {
            navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil)
            
        }
        navigationController?.navigationBar.barTintColor    = .systemGray2
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowRadius = 3
        navigationController?.navigationBar.layer.shadowOpacity = 0.25
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 6)        
    }
    
    @objc private func scrollUp() {
        let topRow = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
}


extension MainVC : UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleAPI                   = isSearching ? filteringData[indexPath.row] : apiData[indexPath.row]
        let vc                          = APIDescriptionVC()
        vc.holder                       = singleAPI
        searchController.isActive       = false
        let presentingVC                = UINavigationController(rootViewController: vc)
        present(presentingVC, animated: true, completion: nil)
        searchController.searchBar.text = ""
        isSearching                     = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { //keeps table from scrolling beyond top but still able to scroll past bottom
        if tableOffset < 0 {
            scrollView.bounces = (scrollView.contentOffset.y > tableOffset)
        } else {
            scrollView.bounces = (scrollView.contentOffset.y > 0)
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var title = "Favorite"
        var isFave = false
        let dataToPullFrom  = isSearching ? filteringData : apiData
        if favorites.count != 0 {
            for x in favorites {
                if dataToPullFrom[indexPath.row].api == x.api {
                    isFave = true
                }
            }
        }
        if isFave {
            title = "Unfavorite"
        }

        let action          = UIContextualAction(style: .normal, title: title) { [weak self] (action, view, completed) in
            guard let self  = self else { return }
                if title == "Unfavorite" {
                    DataManager.shared.removeFavovorite(title: dataToPullFrom[indexPath.row].api) { result in
                        switch result {
                        case .success(_):
                            self.favorites = DataManager.shared.getFavorites()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    DataManager.shared.saveFavorite(api: dataToPullFrom[indexPath.row]) { result in
                        switch result {
                        case .success(_):
                            self.favorites = DataManager.shared.getFavorites()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
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

extension MainVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteringData.count : apiData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datasource = isSearching ? filteringData : apiData
        var isfave = false
        let cell = tableView.dequeueReusableCell(withIdentifier: APICell.reuseID) as! APICell
        let entry = datasource[indexPath.row]
        cell.set(api: entry.api)
        
        for x in favorites {
            if x.api == entry.api {
                isfave = true
            }
        }
        if isfave {
            cell.heart.image = StaticImages.heartFilled
        } else {
            cell.heart.image = StaticImages.heartEmpty
        }
        cell.indexPath = indexPath
        if entry == datasource.last {
            cell.separator.isHidden = true
        } else {
            cell.separator.isHidden = false
            
        }
        return cell
    }
}

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
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.delegate                     = self
        searchController.obscuresBackgroundDuringPresentation   = false
        searchController.hidesNavigationBarDuringPresentation   = false
        searchController.searchBar.backgroundColor              = .systemGray2
        searchController.searchBar.placeholder                  = "Find an API!"
        navigationItem.searchController                         = searchController
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        setUpTableViewBackgroundImage(data: apiData)
        tableView.reloadData()
    }
}



