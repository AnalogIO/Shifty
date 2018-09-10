//
//  EmployeesModels.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities

enum SelectEmployees {
    enum Fetch {
        struct Request {}
        struct Response {
            let employees: Employees
        }
        struct ViewModel {
            let employees: [Employee]
        }
    }
}
