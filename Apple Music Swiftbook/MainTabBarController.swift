//
//  MainTabBarController.swift
//  Apple Music Swiftbook
//
//  Created by Алексей Пархоменко on 17/07/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

protocol MainTabBarControllerDelegate: class {
    func maximizePlayerDetails(viewModel: SearchViewModel.Cell?)
    func minimizePlayerDetails()
}

class MainTabBarController: UITabBarController {
    
    let playerDetaisView: PlayerDetailsView = PlayerDetailsView.loadFromNib()
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        tabBar.tintColor = #colorLiteral(red: 0.9921568627, green: 0.1764705882, blue: 0.3333333333, alpha: 1)
        
        let libraryController = LibraryCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        
        searchVC.tabBarDelegate = self
        viewControllers = [
            generateNavigationController(with: libraryController, title: "Library", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(with: searchVC, title: "Search", image: #imageLiteral(resourceName: "search"))
            
        ]
        
        setupPlayerDetaisView()

    }

    func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
//        navController.navigationBar.prefersLargeTitles = true
        
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}

extension MainTabBarController {
    // MARK: - Setup functions
    
    private func setupPlayerDetaisView() {
        
        view.insertSubview(playerDetaisView, belowSubview: tabBar)
        
        playerDetaisView.translatesAutoresizingMaskIntoConstraints = false
        playerDetaisView.tabBarDelegate = self
        playerDetaisView.delegate = searchVC
        
        maximizedTopAnchorConstraint = playerDetaisView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        
        bottomAnchorConstraint = playerDetaisView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = playerDetaisView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        maximizedTopAnchorConstraint.isActive = true
        
        
        playerDetaisView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetaisView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    
    func maximizePlayerDetails(viewModel: SearchViewModel.Cell?) {
        
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            self.playerDetaisView.maximizedStackView.alpha = 1
            self.playerDetaisView.miniPlayerView.alpha = 0
        }, completion: nil)
        
        guard let viewModel = viewModel else { return }
        playerDetaisView.set(viewModel: viewModel)
    }
    
    func minimizePlayerDetails() {
        
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            
            self.playerDetaisView.maximizedStackView.alpha = 0
            self.playerDetaisView.miniPlayerView.alpha = 1
        }, completion: nil)
    }
}

