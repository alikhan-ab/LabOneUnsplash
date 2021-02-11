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
        
        let mainviewModel = MainViewModel()
        let mainViewController = MainViewController(viewModel: mainviewModel)
        let searchviewModel = SearchViewModel()
        let searchViewController = SearchViewController(viewModel: searchviewModel)
        
        viewControllers = [
            generateNavigationController(rootViewController: mainViewController, title: "random"), // Тут поменяем на иконки
            generateNavigationController(rootViewController: searchViewController, title: "search")
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        return navigationController
    }
}
