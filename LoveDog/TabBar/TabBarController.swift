//
//  TabBarController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureTabItem()
    }
    
    private func configureAppearance(){
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.selected.iconColor = .main
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.main]
        appearance.shadowColor = UIColor.clear
    
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func configureTabItem(){
        let introduceItem = UITabBarItem(title: "소개", image: UIImage(systemName: "heart"), tag: 0)
        let introduceVC = UINavigationController(rootViewController: IntroduceViewController())
        introduceVC.tabBarItem = introduceItem
        
        let communityItem = UITabBarItem(title: "스토리", image: UIImage(systemName: "heart"), tag: 1)
        let communityVC = UINavigationController(rootViewController: StoryViewController(viewModel: StoryViewModel()))
        communityVC.tabBarItem = communityItem
        
        let profileItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "heart"), tag: 2)
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = profileItem
        
        setViewControllers([introduceVC, communityVC, profileVC], animated: true)
    }
}
