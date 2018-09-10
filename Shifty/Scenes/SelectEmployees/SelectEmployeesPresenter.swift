//
//  EmployeesPresenter.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities

protocol SelectEmployeesPresentationLogic {
    func fetchEmployeesStateDidChanged(to state: State<SelectEmployees.Fetch.Response>)
}

class SelectEmployeesPresenter {
    weak var viewController: SelectEmployeesDisplayLogic?
    
    private func formatName(first: String, last: String) -> String {
        return "\(first) \(last)"
    }
}

extension SelectEmployeesPresenter: SelectEmployeesPresentationLogic {
    func fetchEmployeesStateDidChanged(to state: State<SelectEmployees.Fetch.Response>) {
        switch state {
        case .loading:
            viewController?.fetchEmployeesStateDidChanged(to: .loading)
        case .loaded(let response):
            let viewModel = SelectEmployees.Fetch.ViewModel(employees: response.employees.employees)
            viewController?.fetchEmployeesStateDidChanged(to: .loaded(viewModel))
        case .error(let error):
            viewController?.fetchEmployeesStateDidChanged(to: .error(error))
        case .unknown:
            viewController?.fetchEmployeesStateDidChanged(to: .unknown)
        }
    }
}
