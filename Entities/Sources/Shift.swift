//
//  Shift.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Freddy

public struct Shift {
    public let id: Int
    public let start: String
    public let end: String
    public let employees: [Employee]
    public let checkIns: [CheckIn]
    public let scheduleId: Int?
}

extension Shift: JSONDecodable {
    public init(json: JSON) throws {
        id = try json.decode(at: "id")
        start = try json.decode(at: "start")
        end = try json.decode(at: "end")
        employees = try json.decodedArray(at: "employees", type: Employee.self)
        checkIns = try json.decodedArray(at: "checkIns", type: CheckIn.self)
        scheduleId = try json.decode(at: "scheduleId", alongPath: [.nullBecomesNil])
    }
}
