//
//  HomePageViewController.swift
//  News
//
//  Created by 陳冠雄 on 2022/2/27.
//

import UIKit
import UserNotifications

class HomeViewController: UITabBarController {
    
        let viewModel = NewsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        tabBar.barTintColor = .systemFill
        let tab1 = HomwViewController(viewModel: self.viewModel)
        let tab2 = SearchViewController(viewModel: SearchNewsViewModel())
        let tab3 = SavedViewController(viewModel: SavedViewmodel())
        let tab4 = SettingViewController()
        tab1.tabBarItem.image = UIImage(systemName: "house")!.withTintColor(.white,renderingMode: .alwaysOriginal)
        
        tab2.tabBarItem.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.white,renderingMode: .alwaysOriginal)
        tab3.tabBarItem.image = UIImage(systemName: "bookmark.fill")!.withTintColor(.white,renderingMode: .alwaysOriginal)
        tab4.tabBarItem.image = UIImage(systemName: "gear")!.withTintColor(.white,renderingMode: .alwaysOriginal)
        setViewControllers([tab1,tab2,tab3,tab4], animated: true)
        
        tabBar.backgroundColor = .systemFill

        
       
             

    }
    
    
}
