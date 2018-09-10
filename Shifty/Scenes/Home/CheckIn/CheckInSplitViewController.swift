//
//  SplitViewController.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import UIKit

class CheckInSplitViewController: UISplitViewController {
    
    let masterViewController = MasterViewController()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.viewControllers = [UINavigationController(rootViewController: masterViewController)]
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }
}

extension CheckInSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
