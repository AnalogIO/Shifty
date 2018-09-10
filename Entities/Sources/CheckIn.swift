//
//  CheckIn.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Freddy

public struct CheckIn {
    public let id: Int
    public let time: String
    public let employee: Employee
}

extension CheckIn: JSONDecodable {
    public init(json: JSON) throws {
        id = try json.decode(at: "id")
        time = try json.decode(at: "time")
        employee = try json.decode(at: "employee", type: Employee.self)
    }
}
