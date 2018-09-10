//
//  EmployeesInteractor.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities
import ShiftPlanningAPI
import Client

protocol SelectEmployeesBusinessLogic {
    func fetchEmployees()
}

protocol SelectEmployeesDataStore {}

class SelectEmployeesInteractor: SelectEmployeesDataStore {
    var presenter: SelectEmployeesPresentationLogic?

    fileprivate var fetchEmployeesState: State<SelectEmployees.Fetch.Response> = .unknown {
        didSet {
            self.presenter?.fetchEmployeesStateDidChanged(to: fetchEmployeesState)
        }
    }
}

extension SelectEmployeesInteractor: SelectEmployeesBusinessLogic {
    func fetchEmployees() {
        let api = ShiftPlanningAPI()
        fetchEmployeesState = .loading
        Employees.getEmployees().response(using: api, method: .get, parameters: [:], headers: [:]) { [weak self](response: Response<Employees>) in
            switch response {
            case .success(let employees):
                let response = SelectEmployees.Fetch.Response(employees: employees)
                self?.fetchEmployeesState = .loaded(response)
            case .error(let error):
                self?.fetchEmployeesState = .error(error)
            }
        }
    }
}
