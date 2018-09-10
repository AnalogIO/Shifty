//
//  EmployeesRouter.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import UIKit

protocol SelectEmployeesRoutingLogic {
    func didPressDoneButton()
    func didPressCancelButton()
}

protocol SelectEmployeesDataPassing {
    var dataStore: SelectEmployeesDataStore? { get }
}

class SelectEmployeesRouter: SelectEmployeesDataPassing {
    weak var viewController: SelectEmployeesViewController?
    var dataStore: SelectEmployeesDataStore?
}

extension SelectEmployeesRouter: SelectEmployeesRoutingLogic {
    func didPressDoneButton() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func didPressCancelButton() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
