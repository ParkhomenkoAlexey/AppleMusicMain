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
    
    let playerDetaisView: PlayerDetailsView = PlayerDetailsView.loadFromNib()
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    
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
    
    private func setupPlayerDetaisView() {
        
        view.insertSubview(playerDetaisView, belowSubview: tabBar)
        
        playerDetaisView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetaisView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = playerDetaisView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        maximizedTopAnchorConstraint.isActive = true
        
        playerDetaisView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerDetaisView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetaisView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    func maximizePlayerDetails(viewModel: SearchViewModel.Cell?) {
        // эти 2 функции можно было бы обыграть через делегаты, не понятно зачем я таскаю их и вызываю через
//        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
//        mainTabBarController?.minimizePlayerDetails()
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            self.playerDetaisView.maximizedStackView.isHidden = false
            self.playerDetaisView.miniPlayerView.isHidden = true
        }, completion: nil)
        
        
        
        guard let viewModel = viewModel else { return }
        playerDetaisView.set(viewModel: viewModel)
    }
    
    func minimizePlayerDetails() {
        
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            
            self.playerDetaisView.maximizedStackView.isHidden = true
            self.playerDetaisView.miniPlayerView.isHidden = false
        }, completion: nil)
        
        
    }
    
    
}

