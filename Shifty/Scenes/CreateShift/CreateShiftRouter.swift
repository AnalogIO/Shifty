//
//  CreateShiftRouter.swift
//  CheckIn
//
//  Created by Frederik Christensen on 19/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import UIKit

protocol CreateShiftRoutingLogic {
    func didCreateShift()
    func didPressCancelButton()
    func didPressAddEmployees()
}

protocol CreateShiftDataPassing {
    var dataStore: CreateShiftDataStore? { get }
}

class CreateShiftRouter: CreateShiftDataPassing {
    weak var viewController: CreateShiftViewController?
    var dataStore: CreateShiftDataStore?
}

extension CreateShiftRouter: CreateShiftRoutingLogic {
    func didCreateShift() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func didPressCancelButton() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func didPressAddEmployees() {
        guard let viewController = viewController else { return }
        let destinationVC = SelectEmployeesViewController()
        destinationVC.delegate = self
        destinationVC.selectedEmployees = viewController.selectedEmployees
        let navigationController = UINavigationController(rootViewController: destinationVC)
        navigationController.modalPresentationStyle = .overCurrentContext
        viewController.present(navigationController, animated: true, completion: nil)
    }
}

extension CreateShiftRouter: SelectEmployeesDelegate {
    func didCancel() {
        print("Cancel")
    }
    
    func didFinish(employeeIds: [Int]) {
        viewController?.selectedEmployees = employeeIds
    }
}
