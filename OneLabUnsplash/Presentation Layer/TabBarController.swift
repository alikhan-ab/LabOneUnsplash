//
// TabBarController.swift
//  OneLabUnsplash
//
//  Created by Айдана on 2/4/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .black
        tabBar.isTranslucent = false
        tabBar.tintColor = .white
        
        let mainviewModel = MainViewModel()
        let mainViewController = MainViewController(viewModel: mainviewModel)
        let searchviewModel = SearchViewModel()
        let searchViewController = SearchViewController(viewModel: searchviewModel)
        
        viewControllers = [
            generateNavigationController(rootViewController: mainViewController, imageName: "photo.fill"),
            generateNavigationController(rootViewController: searchViewController, imageName: "magnifyingglass")
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        return navigationController
    }
}
