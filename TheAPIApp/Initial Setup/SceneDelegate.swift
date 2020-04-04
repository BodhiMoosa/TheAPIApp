//
//  SceneDelegate.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/15/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene                                   = (scene as? UIWindowScene) else { return }
        window                                                  = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene                                     = windowScene
        window?.rootViewController                              = createTabVC()
        window?.makeKeyAndVisible()
        let attributes                                          = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
              NSAttributedString.Key.font: UIFont(name: StaticFonts.typewriter, size: 24)!
          ]
        UINavigationBar.appearance().titleTextAttributes        = attributes
    }
    
    func createTabVC() -> UITabBarController {
        let vc                                                  = UITabBarController()
        vc.viewControllers                                      = [createHomeVC(), createMainVC(), createCategoriesVC(), createFavoritesVC()]
        vc.tabBar.tintColor                                     = .systemBlue
        vc.tabBar.isTranslucent                                 = false
        vc.tabBar.barTintColor                                  = UIColor.systemGray2
        vc.tabBar.unselectedItemTintColor                       = UIColor.white
        return vc
    }
    
    func createHomeVC() -> UINavigationController {
        let vc                                                  = HomeVC()
        vc.tabBarItem                                           = UITabBarItem(title: "Home", image: StaticImages.home, tag: 0)
        let nav                                                 = UINavigationController(rootViewController: vc)
        nav.navigationBar.barTintColor                          = .systemGray2
        return nav
    }
    
    func createMainVC() -> UINavigationController {
        let vc                                                  = MainVC()
        vc.title                                                = "APIs"
        vc.tabBarItem                                           = UITabBarItem(title: "All APIs", image: StaticImages.list, tag: 1)
        let nav                                                 = UINavigationController(rootViewController: vc)
        nav.navigationBar.backgroundColor                       = .systemGray2
        return nav
    }
    
    func createCategoriesVC() -> UINavigationController {
        let vc                                                  = CategoriesVC()
        vc.title                                                = "API Categories"
        vc.tabBarItem                                           = UITabBarItem(title: "Categories", image: StaticImages.trays, tag: 2)
        let nav                                                 = UINavigationController(rootViewController: vc)
        nav.navigationBar.barTintColor                          = .systemGray2
        return nav
    }
    
    func createFavoritesVC() -> UINavigationController {
        let vc                                                  = FavoritesVC()
        vc.title                                                = "Favorites"
        vc.tabBarItem                                           = UITabBarItem(title: "Favorites", image: StaticImages.heartEmpty, tag: 3)
        let nav                                                 = UINavigationController(rootViewController: vc)
        nav.navigationBar.barTintColor                          = .systemGray2
        return nav
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

