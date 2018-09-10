//
//  TabBarViewController.swift
//  CheckIn
//
//  Created by Frederik Christensen on 23/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import UIKit

protocol HomeTabBarViewControllerDelegate {}

class HomeTabBarViewController: UITabBarController {
    
    private let tabBarTitles = ["Check In", "Coffee card", "Analytics"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureTabBar()
    }

    func configureNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = self.tabBarTitles.first
    }
    
    func configureTabBar() {
        let checkInVC = CheckInSplitViewController()
        let clipCardVC = UINavigationController(rootViewController: CoffeeCardViewController())
        let analyticsVC = UINavigationController(rootViewController: AnalyticsViewController())
        checkInVC.tabBarItem = UITabBarItem.init(title: "Check In", image: #imageLiteral(resourceName: "Clock"), tag: 0)
        clipCardVC.tabBarItem = UITabBarItem.init(title: "Coffee Card", image: #imageLiteral(resourceName: "Card"), tag: 1)
        analyticsVC.tabBarItem = UITabBarItem.init(title: "Analytics", image: #imageLiteral(resourceName: "Graph"), tag: 2)
        self.viewControllers = [checkInVC, clipCardVC, analyticsVC]
    }
}
