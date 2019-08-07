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
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        tabBar.tintColor = #colorLiteral(red: 0.9921568627, green: 0.1764705882, blue: 0.3333333333, alpha: 1)
        
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        viewControllers = [
            generateNavigationController(with: searchVC, title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(with: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(with: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
        
        setupPlayerDetaisView()
        perform(#selector(maximizePlayerDetails), with: nil, afterDelay: 1)
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

extension MainTabBarController {
    // MARK: - Setup functions
    
    @objc func maximizePlayerDetails() {
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func minimizePlayerDetails() {
        
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setupPlayerDetaisView() {
        print("Setting up PlayerDetailsView")
        
        let playerDetaisView: PlayerDetailsView = PlayerDetailsView.loadFromNib()
        //        view.addSubview(playerDetaisView)
        view.insertSubview(playerDetaisView, belowSubview: tabBar)
        
        playerDetaisView.backgroundColor = .red
        playerDetaisView.translatesAutoresizingMaskIntoConstraints = false
        
        //        playerDetaisView.frame = view.frame
        //        enables auto layout
        
        maximizedTopAnchorConstraint = playerDetaisView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = playerDetaisView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        //        minimizedTopAnchorConstraint.isActive = true
        
        
        playerDetaisView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerDetaisView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetaisView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

