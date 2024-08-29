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
        let introduceItem = UITabBarItem(title: Constant.Navigation.introduce, image: UIImage(systemName: "house"), tag: 0)
        let introduceVC = UINavigationController(rootViewController: IntroduceViewController())
        introduceVC.tabBarItem = introduceItem
        
        let storyItem = UITabBarItem(title: Constant.Navigation.story, image: UIImage(systemName: "heart"), tag: 1)
        let storyVC = UINavigationController(rootViewController: StoryViewController(viewModel: StoryViewModel()))
        storyVC.tabBarItem = storyItem
        
        let profileItem = UITabBarItem(title: Constant.Navigation.profile, image: UIImage(systemName: "person"), tag: 2)
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = profileItem
        
        setViewControllers([introduceVC, storyVC, profileVC], animated: true)
    }
}
