//
//  MasterRouter.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import UIKit

protocol MasterRoutingLogic {
    func didPressAddShift()
    func didSelectRow(with shiftId: Int)
}

protocol MasterDataPassing {
    var dataStore: MasterDataStore? { get }
}

class MasterRouter: MasterDataPassing {
    weak var viewController: MasterViewController?
    var dataStore: MasterDataStore?
}

extension MasterRouter: MasterRoutingLogic {
    func didPressAddShift() {
        let destinationVC = CreateShiftViewController()
        destinationVC.delegate = self
        let navigationViewController = UINavigationController(rootViewController: destinationVC)
        navigationViewController.modalPresentationStyle = .formSheet
        viewController?.present(navigationViewController, animated: true, completion: nil)
    }
    func didSelectRow(with shiftId: Int) {
        let detailVC = DetailViewController(shiftId: shiftId)
        let nav = UINavigationController(rootViewController: detailVC)
        viewController?.showDetailViewController(nav, sender: self)
    }
}

extension MasterRouter: CreateShiftDelegate {
    func didCreateShift() {
        viewController?.interactor?.fetchShifts()
    }
}
