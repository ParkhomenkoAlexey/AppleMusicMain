//
//  MainTabBarController.swift
//  Apple Music Swiftbook
//
//  Created by Алексей Пархоменко on 17/07/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        UINavigationBar.appearance().prefersLargeTitles = true
        
        tabBar.tintColor = #colorLiteral(red: 0.9921568627, green: 0.1764705882, blue: 0.3333333333, alpha: 1)
        
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        
        viewControllers = [
            generateNavigationController(with: searchVC, title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(with: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(with: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}

