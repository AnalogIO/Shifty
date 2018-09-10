//
//  Employees+Decodable.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities
import Client

extension Employees {
    public static func getEmployees() -> Request<Employees> {
        return Request(path: "/employees", parser: Employees.init, error: ShiftPlanningError.init)
    }
}
