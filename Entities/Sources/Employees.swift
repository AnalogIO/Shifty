//
//  Employees.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Freddy

public struct Employees {
    public let employees: [Employee]
}

extension Employees: JSONDecodable {
    public init(json: JSON) throws {
        employees = try json.decodedArray(type: Employee.self)
    }
}
