//
//  DetailRouter.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import UIKit

protocol DetailRoutingLogic {
    func didPressAddEmployees()
    func didDeleteShift()
}

protocol DetailDataPassing {
    var dataStore: DetailDataStore? { get }
}

class DetailRouter: DetailDataPassing {
    weak var viewController: DetailViewController?
    var dataStore: DetailDataStore?
}

extension DetailRouter: DetailRoutingLogic {
    func didPressAddEmployees() {
        let destinationVC = SelectEmployeesViewController()
        destinationVC.delegate = self
        if let viewModel = viewController?.viewModel { destinationVC.selectedEmployees = viewModel.employeeIds }
        let navigationController = UINavigationController(rootViewController: destinationVC)
        navigationController.modalPresentationStyle = .formSheet
        viewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func didDeleteShift() {
        guard let splitViewController = viewController?.splitViewController as? CheckInSplitViewController else { return }
        if splitViewController.isCollapsed {
            viewController?.navigationController?.navigationController?.popToRootViewController(animated: true)
        } else {
            splitViewController.setup()
        }
    }
}

extension DetailRouter: SelectEmployeesDelegate {
    func didCancel() {
        print("Cancel")
    }
    
    func didFinish(employeeIds: [Int]) {
        viewController?.updateEmployees(employeeIds: employeeIds)
    }
}
